import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'dart:io' as io show Directory, File;

import 'widgets/quill_delta_sample.dart';

class CommentTaskScreen extends StatefulWidget {
  const CommentTaskScreen({super.key});

  @override
  State<CommentTaskScreen> createState() => _CommentTaskScreenState();
}

class _CommentTaskScreenState extends State<CommentTaskScreen> {
  final QuillController _controller = () {
    return QuillController.basic(
      config: QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          enableExternalRichPaste: true,
          onImagePaste: (imageBytes) async {
            if (kIsWeb) {
              // Dart IO is unsupported on the web.
              return null;
            }
            // Save the image somewhere and return the image URL that will be
            // stored in the Quill Delta JSON (the document).
            final newFileName = 'image-file-${DateTime.now().toIso8601String()}.png';
            final newPath = path.join(io.Directory.systemTemp.path, newFileName);
            final file = await io.File(newPath).writeAsBytes(imageBytes, flush: true);
            return file.path;
          },
        ),
      ),
    );
  }();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  late List<FocusNode> _focusNodes;
  late List<ScrollController> _scrollControllers;
  late List<QuillController> _commentControllers;
  int countData = 5;
  @override
  void initState() {
    super.initState();
    // Load document
    _controller.document = Document.fromJson(kQuillDefaultSample);
    _focusNodes = List.generate(countData, (_) => FocusNode());
    _scrollControllers = List.generate(countData, (_) => ScrollController());
    // 🔧 Initialize QuillControllers for each comment
    final doc = TimeStampEmbed.fromDocument(_controller.document).document;
    _commentControllers = List.generate(
      countData,
      (_) => QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0), readOnly: true, keepStyleOnNewLine: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Flutter Quill Example'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.output),
      //       tooltip: 'Print Delta JSON to log',
      //       onPressed: () {
      //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The JSON Delta has been printed to the console.')));
      //         debugPrint(jsonEncode(_controller.document.toDelta().toJson()));
      //       },
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) => ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          // radius: 20,
                          child: Image.network('https://cdn-icons-png.flaticon.com/512/8792/8792047.png', width: 40, height: 40, fit: BoxFit.cover),
                        ),
                        Container(
                          width: constraints.maxWidth - 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              HeaderWidget(controller: _controller, editorFocusNode: _editorFocusNode),
                              QuillEditor(
                                focusNode: _editorFocusNode,
                                scrollController: _editorScrollController,
                                controller: _controller,
                                config: QuillEditorConfig(
                                  scrollable: true,
                                  placeholder: 'Start writing your notes...',
                                  padding: const EdgeInsets.all(16),
                                  embedBuilders: [
                                    ...FlutterQuillEmbeds.editorBuilders(
                                      imageEmbedConfig: QuillEditorImageEmbedConfig(
                                        imageProviderBuilder: (context, imageUrl) {
                                          if (imageUrl.startsWith('assets/')) {
                                            return AssetImage(imageUrl);
                                          }
                                          return null;
                                        },
                                      ),
                                      videoEmbedConfig: QuillEditorVideoEmbedConfig(
                                        customVideoBuilder: (videoUrl, readOnly) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    TimeStampEmbedBuilder(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // data Edit is Not Empty
                  if (_controller.document.toDelta().length > 1)
                    // Save Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 10,
                        children: [FilledButton(onPressed: null, child: const Text('Save')), TextButton(onPressed: null, child: const Text('Cancel'))],
                      ),
                    ),
                  // add Listview.builder to display the document content
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: countData,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Profile picture
                            CircleAvatar(
                              // radius: 20,
                              child: Image.network('https://cdn-icons-png.flaticon.com/512/8792/8792047.png', width: 40, height: 40, fit: BoxFit.cover),
                            ),
                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("User Name $index", style: const TextStyle(fontWeight: FontWeight.bold)),
                                // 5 hours ago
                                Text('5 hours ago', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                Container(
                                  width: constraints.maxWidth - 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: QuillEditor(
                                    focusNode: _focusNodes[index],
                                    scrollController: _scrollControllers[index],
                                    controller: _commentControllers[index],
                                    config: QuillEditorConfig(
                                      enableAlwaysIndentOnTab: false,
                                      editorKey: GlobalKey(),
                                      enableScribble: false,
                                      readOnlyMouseCursor: SystemMouseCursors.basic,
                                      scrollable: false,
                                      showCursor: false,
                                      onTapUp: (details, p1) => false,
                                      padding: const EdgeInsets.all(16),
                                      embedBuilders: [
                                        ...FlutterQuillEmbeds.editorBuilders(
                                          imageEmbedConfig: QuillEditorImageEmbedConfig(
                                            imageProviderBuilder: (context, imageUrl) {
                                              if (imageUrl.startsWith('assets/')) {
                                                return AssetImage(imageUrl);
                                              }
                                              return null;
                                            },
                                          ),
                                          videoEmbedConfig: QuillEditorVideoEmbedConfig(
                                            customVideoBuilder: (videoUrl, readOnly) {
                                              return null;
                                            },
                                          ),
                                        ),
                                        TimeStampEmbedBuilder(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final ctrl in _scrollControllers) {
      ctrl.dispose();
    }
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required QuillController controller, required FocusNode editorFocusNode})
    : _controller = controller,
      _editorFocusNode = editorFocusNode;

  final QuillController _controller;
  final FocusNode _editorFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: QuillSimpleToolbar(
        // disable increate indent button
        controller: _controller,
        config: QuillSimpleToolbarConfig(
          showIndent: false,
          showAlignmentButtons: false,
          showHeaderStyle: true,
          showClipboardPaste: true,
          showBackgroundColorButton: false,
          showUnderLineButton: true,
          showItalicButton: false,
          showSubscript: false,
          showSuperscript: false,
          embedButtons: FlutterQuillEmbeds.toolbarButtons(videoButtonOptions: null),
          showFontFamily: false,
          showFontSize: false,
          buttonOptions: QuillSimpleToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              afterButtonPressed: () {
                final isDesktop = {TargetPlatform.linux, TargetPlatform.windows, TargetPlatform.macOS}.contains(defaultTargetPlatform);
                if (isDesktop) {
                  Future.microtask(() {
                    _editorFocusNode.requestFocus();
                  });
                }
              },
            ),
            linkStyle: QuillToolbarLinkStyleButtonOptions(
              validateLink: (link) {
                // Treats all links as valid. When launching the URL,
                // `https://` is prefixed if the link is incomplete (e.g., `google.com` → `https://google.com`)
                // however this happens only within the editor.
                return true;
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(String value) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) => TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return Row(children: [const Icon(Icons.access_time_rounded), Text(embedContext.node.value.data as String)]);
  }
}
