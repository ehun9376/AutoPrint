import 'dart:html'; // Web 端使用
import 'dart:typed_data';
import 'package:auto_print/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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

  Future<void> _uploadImage() async {
    final uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final file = uploadInput.files?.first;
      if (file == null) return;

      setState(() {
        _isUploading = true;
        _status = '準備上傳...';
      });

      try {
        // 讀取檔案
        final reader = FileReader();
        reader.readAsArrayBuffer(file);

        await reader.onLoad.first;
        final bytes = reader.result as Uint8List;

        debugPrint('檔案大小: ${bytes.length} bytes');
        debugPrint('檔案類型: ${file.type}');

        // 準備上傳
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}'
            .replaceAll(' ', '_')
            .replaceAll('/', '_');

        debugPrint('準備上傳檔案: $fileName');

        final ref = FirebaseStorage.instance.ref().child('photos/$fileName');

        // 設置metadata
        final metadata = SettableMetadata(
          contentType: file.type,
          customMetadata: {'fileName': file.name},
        );

        // 開始上傳
        final uploadTask = ref.putData(bytes, metadata);

        // 監聽上傳進度
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

        // 等待上傳完成
        try {
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
        } catch (uploadError) {
          debugPrint('上傳任務錯誤: $uploadError');
          throw uploadError;
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
    });
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
              if (_isUploading) ...[
                CircularProgressIndicator(value: _uploadProgress / 100),
                const SizedBox(height: 16),
                Text(_status),
                const SizedBox(height: 16),
              ],
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadImage,
                icon: const Icon(Icons.upload),
                label: const Text('選擇照片上傳'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
