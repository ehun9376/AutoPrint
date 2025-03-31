import 'dart:async';
import 'dart:html'; // Web 端使用
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_print/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '照片上傳',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const UploadPage(),
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isUploading = false;
  double _uploadProgress = 0;
  String _status = '';
  ui.Image? _userImage;
  double _scale = 1.0;
  Offset _position = Offset.zero;
  bool _isDragging = false;
  String _selectedFrame = 'assets/images/photo1.png';
  final List<String> _frames = [
    'assets/images/photo1.png',
    'assets/images/photo2.png',
  ];

  // 添加一個 GlobalKey 來引用 RepaintBoundary
  final GlobalKey _previewKey = GlobalKey();

  // 載入背景圖片
  Future<ui.Image> _loadBackgroundImage() async {
    final completer = Completer<ui.Image>();
    AssetImage(
      _selectedFrame, // 使用選中的相框
    ).resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        completer.complete(info.image);
      }),
    );
    return completer.future;
  }

  // 選擇照片
  Future<void> _selectImage() async {
    final uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final file = uploadInput.files?.first;
      if (file == null) return;

      try {
        // 讀取檔案
        final reader = FileReader();
        reader.readAsArrayBuffer(file);

        await reader.onLoad.first;
        final bytes = reader.result as Uint8List;

        // 載入預覽圖片
        final completer = Completer<ui.Image>();
        ui.decodeImageFromList(bytes, (result) {
          completer.complete(result);
        });

        final image = await completer.future;

        setState(() {
          _userImage = image;
          _scale = 1.0;
          _position = Offset.zero;
        });
      } catch (e) {
        debugPrint('載入圖片錯誤: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('載入圖片失敗: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  // 上傳合成照片
  Future<void> _uploadCompositeImage() async {
    if (_userImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請先選擇照片')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _status = '準備上傳...';
    });

    try {
      // 合成圖片
      final compositeBytes = await _compositeImages();

      debugPrint('準備上傳合成圖片');

      // 上傳合成後的圖片
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_composite.png';
      final ref = FirebaseStorage.instance.ref().child('photos/$fileName');

      final metadata = SettableMetadata(
        contentType: 'image/png',
        customMetadata: {'fileName': fileName},
      );

      final uploadTask = ref.putData(compositeBytes, metadata);

      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress =
                (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            _status =
                '上傳中... ${_uploadProgress.toStringAsFixed(1)}% (${(snapshot.bytesTransferred / 1024).toStringAsFixed(1)}KB/${(snapshot.totalBytes / 1024).toStringAsFixed(1)}KB)';
          });
          debugPrint('上傳進度: ${_uploadProgress.toStringAsFixed(1)}%');
        },
        onError: (error) {
          debugPrint('上傳過程錯誤: $error');
          throw error;
        },
      );

      await uploadTask;
      debugPrint('上傳完成');

      setState(() {
        _status = '上傳完成！';
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('照片上傳成功！')),
        );
      }
    } catch (e) {
      debugPrint('發生錯誤: $e');
      setState(() {
        _status = '上傳失敗: $e';
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('上傳失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 修改合成方法，改用截圖方式
  Future<Uint8List> _compositeImages() async {
    try {
      // 獲取 RepaintBoundary 的渲染對象
      final RenderRepaintBoundary boundary = _previewKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // 將渲染對象轉換為圖片
      final image = await boundary.toImage(pixelRatio: 2.0); // 使用2倍像素比以獲得更好的品質
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData!.buffer.asUint8List();
    } catch (e) {
      debugPrint('截圖錯誤: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('照片上傳'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 添加相框選擇列表
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _frames.length,
                  itemBuilder: (context, index) {
                    final frame = _frames[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFrame = frame;
                          });
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedFrame == frame
                                  ? Colors.blue
                                  : Colors.grey,
                              width: _selectedFrame == frame ? 2 : 1,
                            ),
                          ),
                          child: Image.asset(
                            frame,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (_userImage != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 編輯區域
                    Column(
                      children: [
                        RepaintBoundary(
                          key: _previewKey,
                          child: GestureDetector(
                            onScaleStart: (details) {
                              _isDragging = true;
                            },
                            onScaleUpdate: (details) {
                              setState(() {
                                if (_isDragging) {
                                  _position += details.focalPointDelta;
                                  if (details.scale != 1.0) {
                                    _scale = (_scale * details.scale);
                                  }
                                }
                              });
                            },
                            onScaleEnd: (details) {
                              _isDragging = false;
                            },
                            child: Container(
                              width: 300,
                              height: 400,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                fit: StackFit.passthrough,
                                children: [
                                  if (_userImage != null)
                                    Positioned(
                                      left: _position.dx,
                                      top: _position.dy,
                                      child: Transform.scale(
                                        scale: _scale,
                                        child: RawImage(
                                          image: _userImage,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  Image.asset(
                                    _selectedFrame,
                                    width: 300,
                                    height: 400,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Text('編輯區域'),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              if (_userImage != null) ...[
                // 添加控制按鈕
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () {
                        setState(() {
                          _scale = (_scale * 1.1);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: () {
                        setState(() {
                          _scale = (_scale * 0.9);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          _scale = 1.0;
                          _position = Offset.zero;
                        });
                      },
                      tooltip: '重置位置和大小',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              if (_isUploading) ...[
                CircularProgressIndicator(value: _uploadProgress / 100),
                const SizedBox(height: 16),
                Text(_status),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _selectImage,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('新增照片'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _isUploading || _userImage == null
                        ? null
                        : _uploadCompositeImage,
                    icon: const Icon(Icons.upload),
                    label: const Text('上傳合成'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
