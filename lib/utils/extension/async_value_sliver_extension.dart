import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueSliverX<T> on AsyncValue<T> {
  /// สร้าง Sliver UI เมื่อ state เปลี่ยน
  ///
  /// - [dataBuilder] สร้าง Sliver เมื่อโหลดสำเร็จ
  /// - [empty] Widget แสดงถ้าไม่มีข้อมูล (optional)
  /// - [loading] Widget แสดงระหว่างโหลด (optional)
  /// - [error] Widget แสดงถ้า error (optional)
  Widget appSliverWhen({required Widget Function(T data) dataBuilder, Widget? loading, Widget? error}) {
    return when(
      data: (data) => dataBuilder(data),
      loading: () => SliverToBoxAdapter(child: loading ?? const Center(child: CircularProgressIndicator())),
      error: (err, stx) => SliverToBoxAdapter(child: error ?? Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red)))),
    );
  }

  Widget appWhen({required Widget Function(T data) dataBuilder, Widget? empty, Widget? loading, Widget? error}) {
    return when(
      data: (data) => dataBuilder(data),
      loading: () => loading ?? const Center(child: CircularProgressIndicator()),
      error: (err, stx) => error ?? Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }
}
