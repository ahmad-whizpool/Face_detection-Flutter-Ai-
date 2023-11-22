import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ShaderExample extends StatefulWidget {
  const ShaderExample({super.key});

  @override
  State<ShaderExample> createState() => _ShaderExampleState();
}

class _ShaderExampleState extends State<ShaderExample> {
  double _value = 2.0;

  void _onChanged(double newValue) {
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Shaders!')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SampledText(text: 'This is some sampled text', value: _value),
              Slider(value: _value, onChanged: _onChanged, min: 2, max: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class SampledText extends StatefulWidget {
  const SampledText({super.key, required this.text, required this.value});

  final String text;
  final double value;

  @override
  State<SampledText> createState() => _SampledTextState();
}

class _SampledTextState extends State<SampledText> {
  ui.FragmentProgram? shader;
  ui.Image? image;
  @override
  void initState() {
    super.initState();
    getImage();
    loadMyShader();
  }

  void getImage() async {
    final byteimage =
        (await rootBundle.load('assets/masks.png')).buffer.asUint8List();
    ui.decodeImageFromList(byteimage, (result) {
      setState(() {
        image = result;
      });
    });
  }

  void loadMyShader() async {
    shader =
        await ui.FragmentProgram.fromAsset('assets/shaders/ink_sparkle.frag');
  }

  @override
  Widget build(BuildContext context) {
    return shader != null && image != null
        ? Center(
            child: SizedBox(
              height: 400,
              child: CustomPaint(
                size: Size(image!.width.toDouble(), image!.height.toDouble()),
                painter: MyPainter(shader!.fragmentShader(), image!),
              ),
            ),
          )
        : const SizedBox();
  }
}

class MyPainter extends CustomPainter {
  final FragmentShader shader;
  final ui.Image image;
  MyPainter(this.shader, this.image);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, const Offset(0, 0), Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
