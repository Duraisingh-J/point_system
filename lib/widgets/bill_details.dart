import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_system/provider/bill_items_provider.dart';
import 'package:point_system/provider/shops_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:point_system/widgets/bill_image.dart';
import 'package:share_plus/share_plus.dart';

class BillDetails extends ConsumerStatefulWidget {
  const BillDetails({super.key});

  @override
  ConsumerState<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends ConsumerState<BillDetails> {
  final GlobalKey _billPdfKey = GlobalKey();
  bool _isCapturing = false;
  String _billPayment = 'Pending';

  void confirmPrint() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Print Bill'),
        content: Text('Do you want to print the bill?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _billPayment = 'Completed';
              });
              Navigator.of(ctx).pop();
              _captureAndShare();
            },
            child: Text('Cash on Delivery'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _billPayment = 'Pending';
              });
              Navigator.of(ctx).pop();
              _captureAndShare();
            },
            child: Text('Later'),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndShare() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      await _ensureWidgetIsReady();

      final boundary =
          _billPdfKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      // Wait for multiple frames to ensure painting is complete
      await _waitForPaintingToComplete(boundary);

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final imageBytes = byteData!.buffer.asUint8List();

      final pdfFile = await _generatePdf(imageBytes);
      await _sharePdf(pdfFile);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to share bill: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      print('Capture error: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _ensureWidgetIsReady() async {
    // First, force a rebuild
    setState(() {});

    // Wait for the widget to be attached to the tree
    int attempts = 0;
    const maxAttempts = 20;

    while (_billPdfKey.currentContext == null && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 50));
      attempts++;
    }

    if (_billPdfKey.currentContext == null) {
      throw Exception('Bill widget is not ready for capture after waiting.');
    }

    // Wait for the render object to be available
    attempts = 0;
    while (_billPdfKey.currentContext!.findRenderObject() == null &&
        attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 50));
      attempts++;
    }

    final renderObject = _billPdfKey.currentContext!.findRenderObject();
    if (renderObject == null) {
      throw Exception('Render object not found.');
    }
  }

  Future<void> _waitForPaintingToComplete(
    RenderRepaintBoundary boundary,
  ) async {
    // Wait for multiple frames and check painting status
    int attempts = 0;
    const maxAttempts = 20;

    while (boundary.debugNeedsPaint && attempts < maxAttempts) {
      // Wait for the current frame to complete
      await WidgetsBinding.instance.endOfFrame;

      // Small delay to allow painting to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Force a frame if needed
      WidgetsBinding.instance.scheduleFrame();
      await WidgetsBinding.instance.endOfFrame;

      attempts++;
      print(
        'Waiting for painting to complete, attempt: $attempts, needsPaint: ${boundary.debugNeedsPaint}',
      );
    }

    if (boundary.debugNeedsPaint) {
      // Last resort: wait longer and try again
      await Future.delayed(const Duration(milliseconds: 500));
      WidgetsBinding.instance.scheduleFrame();
      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(const Duration(milliseconds: 200));

      if (boundary.debugNeedsPaint) {
        throw Exception('Widget is still painting after multiple attempts');
      }
    }

    print(
      'Widget is ready for capture, needsPaint: ${boundary.debugNeedsPaint}',
    );
  }

  Future<File> _generatePdf(Uint8List imageBytes) async {
    final pdf = pw.Document();

    // Get image dimensions
    final codec = await instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final imageWidth = frame.image.width.toDouble();
    final imageHeight = frame.image.height.toDouble();

    // A4 page dimensions in points (72 DPI)
    double pageWidth = PdfPageFormat.a4.width;
    double pageHeight = PdfPageFormat.a4.height;
    double margin = 20;
    double usableWidth = pageWidth - (2 * margin);
    double usableHeight =
        pageHeight - (2 * margin) - 30; // Reserve space for page number

    // Calculate scaling factor to fit width
    final double scaleFactor = usableWidth / imageWidth;
    final double scaledHeight = imageHeight * scaleFactor;

    print('Image dimensions: ${imageWidth}x$imageHeight');
    print('Scaled height: $scaledHeight, Page height: $usableHeight');

    final image = pw.MemoryImage(imageBytes);

    // If the scaled image fits in one page, use single page
    if (scaledHeight <= usableHeight) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(margin),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                image,
                width: usableWidth,
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
    } else {
      // Split image into multiple pages using a simpler approach
      final int numberOfPages = (scaledHeight / usableHeight).ceil();
      print('Creating $numberOfPages pages');

      for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++) {
        // Calculate what portion of the image to show on this page
        final double pageStartY = pageIndex * usableHeight;
        final double pageEndY = (pageIndex + 1) * usableHeight;
        final double actualEndY = pageEndY > scaledHeight
            ? scaledHeight
            : pageEndY;
        final double thisPageHeight = actualEndY - pageStartY;

        print(
          'Page ${pageIndex + 1}: startY=$pageStartY, endY=$actualEndY, height=$thisPageHeight',
        );

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(margin),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Page number
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Page ${pageIndex + 1} of $numberOfPages',
                      style: pw.TextStyle(
                        fontSize: 5,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // Image with clipping
                  pw.Container(
                    width: usableWidth,
                    height: thisPageHeight,
                    child: pw.Stack(
                      children: [
                        pw.Positioned(
                          left: 0,
                          top: -pageStartY, // Offset the image upward
                          child: pw.Image(
                            image,
                            width: usableWidth,
                            height: scaledHeight,
                            fit: pw.BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }
    }

    final output = await getTemporaryDirectory();
    final file = File(
      "${output.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _sharePdf(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Here is your bill',
      subject: 'Bill Details',
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(billItemsProvider);
    final shop = ref.watch(shopProvider);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No items in the bill',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              height: MediaQuery.of(context).size.height * 0.62,
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Compact header - reduced font sizes and spacing
                  Text(
                    'Shop Name: XYZ Shop',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2), // Reduced from 3
                  Text(
                    'Phone Number: 1234567890',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15), // Reduced from 30
                  // Compact customer info and date section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: TextStyle(
                              fontSize: 10, // Reduced from 10
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2), // Reduced from 5
                          Text(
                            shop.name,
                            style: TextStyle(fontSize: 10),
                          ), // Reduced from 10
                          SizedBox(height: 1), // Reduced from 2
                          Text(
                            '+91 ${shop.phno}',
                            style: TextStyle(fontSize: 10), // Reduced from 10
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                            style: TextStyle(fontSize: 10),
                             // Reduced from 10
                          ),
                          SizedBox(height: 8), // Reduced from 5
                          Text('Payment Status: $_billPayment',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                             // Reduced from 10
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6), // Reduced from 10
                  Divider(
                    color: Colors.black,
                    thickness: 0.8,
                    height: 10,
                  ), // Reduced thickness and height

                  SizedBox(height: 6), // Reduced from 10

                  Column(
                    children: [
                      // Compact Header Row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 4.0, // Reduced from 6.0
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 10, // Reduced from 10
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 4.0), // Reduced from 7.0
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Qty',
                                style: TextStyle(
                                  fontSize: 10, // Reduced from 10
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 10, // Reduced from 10
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            SizedBox(width: 4.0), // Reduced from 10.0
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 10, // Reduced from 10
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6), // Reduced from 10
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 0.8, // Reduced from 1
                        dashLength: 3, // Reduced from 4
                      ),

                      const SizedBox(height: 6), // Reduced from 10
                      // Compact item rows
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0, // Reduced from 4.0
                            horizontal: 4.0, // Reduced from 6.0
                          ),
                          child: GestureDetector(
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text('Remove Item'),
                                  content: Text(
                                    'Are you sure you want to remove ${item.title}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.grey[700],
                                        backgroundColor: Colors.grey[200],
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref
                                            .read(billItemsProvider.notifier)
                                            .removeItem(item);
                                        Navigator.of(ctx).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text('Remove'),
                                    ),
                                  ],
                                );
                              },
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    item.title,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ), // Reduced from 10
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    (item.quantity.name == 'kg' ||
                                            item.quantity.name == 'g')
                                        ? '${item.quantityInGrams}${item.selectedQuantity.name}'
                                        : '${item.quantityInGrams.toInt()}${item.selectedQuantity.name}',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ), // Reduced from 10
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${item.retailPrice}/${item.quantity.name}',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ), // Reduced from 10
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.totalPrice.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ), // Reduced from 10
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6), // Reduced from 10
                  DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 0.8, // Reduced from 1
                    dashLength: 3, // Reduced from 4
                  ),

                  const SizedBox(height: 6), // Reduced from 10
                  // Compact total section
                  Row(
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 12, // Reduced from 20
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${items.fold(0.0, (sum, item) => (sum + item.totalPrice).toDouble())}',
                        style: TextStyle(
                          fontSize: 12, // Reduced from 20
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6), // Reduced from 10
                    ],
                  ),

                  const SizedBox(height: 8), // Reduced from 10
                  // Compact points circle
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 50, // Reduced from 70
                      width: 50, // Reduced from 70
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 1.5,
                        ), // Reduced border width
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Point',
                            style: TextStyle(
                              fontSize: 10, // Reduced from 15
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '100',
                            style: TextStyle(
                              fontSize: 10, // Reduced from 15
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5), // Reduced from 20
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton.icon(
                      onPressed: confirmPrint,
                      icon: Icon(Icons.print, size: 30),
                      label: Text(
                        'Print',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                          // ignore: deprecated_member_use
                        ).colorScheme.primary.withOpacity(0.8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isCapturing
                        ? null
                        : shop.name.isEmpty || shop.phno.isEmpty
                        ? () {
                            Fluttertoast.showToast(
                              msg: "Please enter shop details before sharing.",
                            );
                          }
                        : _captureAndShare,
                    icon: _isCapturing
                        ? CircularProgressIndicator(strokeWidth: 2.0)
                        : Icon(Icons.share, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Reduced from 20
            // Create a properly rendered invisible widget for capture
            Positioned(
              left: -1000, // Move off-screen
              top: 0,
              child: BillImage(
                billPdfKey: _billPdfKey,
                billPayment: _billPayment,
                items: items,
                shop: shop,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
