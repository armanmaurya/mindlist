import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo_native/notes/models/note.dart';
import 'package:todo_native/notes/services/notes_service.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class QuillEditorScreen extends StatefulWidget {
  final Note note;
  const QuillEditorScreen({super.key, required this.note});

  @override
  State<QuillEditorScreen> createState() => _QuillEditorScreenState();
}

class _QuillEditorScreenState extends State<QuillEditorScreen> {
  late QuillController _controller;
  bool _isDeleting = false;
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        final newTitle = _titleController.text.trim();
        if (newTitle.isNotEmpty && newTitle != widget.note.title) {
          NotesService().updateNoteTitle(widget.note.id!, newTitle);
        }
      }
    });
    // Initialize the QuillController
    // Use note.data as the JSON string for the document, fallback to empty doc
    _controller = QuillController(
      document:
          (widget.note.data != null && widget.note.data!.isNotEmpty)
              ? Document.fromJson(jsonDecode(widget.note.data!))
              : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void saveDocument() {
    // Convert the document to JSON and save it
    final json = jsonEncode(_controller.document.toDelta().toJson());
    NotesService()
        .updateNoteData(widget.note.id!, json)
        .then((_) {
          // Update the last updated time
          setState(() {
            widget.note.lastUpdated = DateTime.now();
          });
        })
        .catchError((error) {
          // Handle any errors that occur during saving
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving note: $error')));
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop || _isDeleting) return;
        saveDocument();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Text(timeago.format(widget.note.lastUpdated, allowFromNow: true)),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                saveDocument();
              },
            ),

            // Vertical three dots menu for more options
            PopupMenuButton(
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      child: Text('Delete'),
                      onTap: () {
                        setState(() {
                          _isDeleting = true;
                        });
                        NotesService()
                            .deleteNote(widget.note.id!)
                            .then((_) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            })
                            .catchError((error) {
                              setState(() {
                                _isDeleting = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error deleting note: $error'),
                                ),
                              );
                            });
                      },
                    ),
                  ],
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                textInputAction: TextInputAction.done,
                maxLines: 1,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: QuillEditor.basic(
                  controller: _controller,
                  config: QuillEditorConfig(
                    placeholder: 'Write your note here...',
                    autoFocus: true,
                    // embedBuilders: [
                    //   QuillEditorImageEmbedBuilder(
                    //     config: QuillEditorImageEmbedConfig(),
                    //   ),
                    // ],
                  ),
                  scrollController: ScrollController(),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  QuillToolbarHistoryButton(
                    isUndo: true,
                    controller: _controller,
                  ),
                  QuillToolbarHistoryButton(
                    isUndo: false,
                    controller: _controller,
                  ),
                  _verticalDivider(),
                  QuillToolbarToggleStyleButton(
                    options: const QuillToolbarToggleStyleButtonOptions(),
                    controller: _controller,
                    attribute: Attribute.bold,
                  ),
                  QuillToolbarToggleStyleButton(
                    options: const QuillToolbarToggleStyleButtonOptions(),
                    controller: _controller,
                    attribute: Attribute.italic,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: _controller,
                    attribute: Attribute.underline,
                  ),
                  _verticalDivider(),
                  QuillToolbarClearFormatButton(controller: _controller),
                  QuillToolbarColorButton(
                    controller: _controller,
                    isBackground: false,
                  ),
                  QuillToolbarColorButton(
                    controller: _controller,
                    isBackground: true,
                  ),
                  _verticalDivider(),
                  QuillToolbarSelectHeaderStyleButtons(
                    controller: _controller,
                    options: QuillToolbarSelectHeaderStyleButtonsOptions(
                      iconSize: 24,
                    ),
                  ),
                  _verticalDivider(),
                  QuillToolbarToggleCheckListButton(controller: _controller),
                  QuillToolbarToggleStyleButton(
                    controller: _controller,
                    attribute: Attribute.ol,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: _controller,
                    attribute: Attribute.ul,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: _controller,
                    attribute: Attribute.inlineCode,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: _controller,
                    attribute: Attribute.blockQuote,
                  ),
                  _verticalDivider(),
                  QuillToolbarIndentButton(
                    controller: _controller,
                    isIncrease: true,
                  ),
                  QuillToolbarIndentButton(
                    controller: _controller,
                    isIncrease: false,
                  ),
                  _verticalDivider(),
                  QuillToolbarLinkStyleButton(controller: _controller),
                  // Image button
                  // QuillToolbarImageButton(controller: _controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider() => Container(
    width: 1,
    height: 32,
    color: Colors.grey.shade300,
    margin: const EdgeInsets.symmetric(horizontal: 8),
  );
}
