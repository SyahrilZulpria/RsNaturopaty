import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewTreeReportMember extends StatefulWidget {
  final String urlMember;
  const ViewTreeReportMember({
    super.key,
    required this.urlMember,
  });

  @override
  State<ViewTreeReportMember> createState() => _ViewTreeReportMemberState();
}

class _ViewTreeReportMemberState extends State<ViewTreeReportMember> {
  String token = '';
  late Map<String, dynamic> transactionData = {};
  bool showIframe = true;
  html.IFrameElement? iframe;

  @override
  void initState() {
    super.initState();
    createIFrame();
  }

  @override
  void dispose() {
    super.dispose();
    iframe?.remove();
  }

  void createIFrame() {
    // Create an iframe element
    iframe = html.IFrameElement()
      ..width = '400' // Adjust width
      ..height = '300' // Adjust height
      ..src = widget.urlMember.toString();
    // Provide the URL of the content to embed

    // Set position and style properties
    iframe!.style
      ..position = 'absolute'
      ..top = '10%'
      ..left = '0'
      ..width = '100%'
      ..height = '100%'
      ..border = 'none';

    // Add the iframe to the HTML body
    html.document.body?.append(iframe!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Member",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
            iframe?.remove();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (showIframe)
              const HtmlElementView(viewType: 'Tree Report Member'),
          ],
        ),
      ),
    );
  }
}
