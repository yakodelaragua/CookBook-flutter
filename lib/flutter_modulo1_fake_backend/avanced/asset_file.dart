
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
/*
* Esta clase ha sido creada para poder cargar un archivo dentro de Asset desde
* una instancia de File
* */

class AssetFile implements File {
  final AssetBundle assetBundle;
  final String filePath;


  AssetFile(this.assetBundle, this.filePath);


  @override
  Future<Uint8List> readAsBytes() async {
    final ByteData bytes = await assetBundle.load(filePath);
    return bytes.buffer.asUint8List();
  }



  @override
  // TODO: implement absolute
  File get absolute => File('');

  @override
  Future<File> copy(String newPath) {
    // TODO: implement copy
    return Future<File>.value(null);
  }

  @override
  File copySync(String newPath) {
    // TODO: implement copySync
    return File('');
  }

  @override
  Future<File> create({bool recursive = false}) {
    // TODO: implement create
    return Future<File>.value(null);
  }

  @override
  void createSync({bool recursive = false}) {
    // TODO: implement createSync
  }

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) {
    // TODO: implement delete
    return Future<File>.value(null);
  }

  @override
  void deleteSync({bool recursive = false}) {
    // TODO: implement deleteSync
  }

  @override
  Future<bool> exists() {
    // TODO: implement exists
    return Future<bool>.value(null);
  }

  @override
  bool existsSync() {
    // TODO: implement existsSync
    return true;
  }

  @override
  // TODO: implement isAbsolute
  bool get isAbsolute => true;

  @override
  Future<DateTime> lastAccessed() {
    // TODO: implement lastAccessed
    return Future<DateTime>.value(null);
  }

  @override
  DateTime lastAccessedSync() {
    // TODO: implement lastAccessedSync
    return DateTime(2000);
  }

  @override
  Future<DateTime> lastModified() {
    // TODO: implement lastModified
    return Future<DateTime>.value(null);
  }

  @override
  DateTime lastModifiedSync() {
    // TODO: implement lastModifiedSync
    return DateTime(2000);
  }

  @override
  Future<int> length() {
    // TODO: implement length
    return Future.value(null);
  }

  @override
  int lengthSync() {
    // TODO: implement lengthSync
    return 0;
  }

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) {
    // TODO: implement open
    return Future.value(null);
  }






  @override
  // TODO: implement parent
  Directory get parent => Directory('path');

  @override
  // TODO: implement path
  String get path => filePath;


  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) {
    // TODO: implement readAsLines
    return Future.value(null);
  }

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) {
    // TODO: implement readAsLinesSync
    return List<String>.empty();
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    // TODO: implement readAsString
    return Future.value(null);
  }

  @override
  String readAsStringSync({Encoding encoding = utf8}) {
    // TODO: implement readAsStringSync
    return 'null';
  }

  @override
  Future<File> rename(String newPath) {
    // TODO: implement rename
    return Future.value(null);
  }



  @override
  Future<String> resolveSymbolicLinks() {
    // TODO: implement resolveSymbolicLinks
    return Future.value(null);
  }

  @override
  String resolveSymbolicLinksSync() {
    // TODO: implement resolveSymbolicLinksSync
    return '';
  }

  @override
  Future setLastAccessed(DateTime time) {
    // TODO: implement setLastAccessed
    return Future.value(null);
  }

  @override
  void setLastAccessedSync(DateTime time) {
    // TODO: implement setLastAccessedSync
  }

  @override
  Future setLastModified(DateTime time) {
    // TODO: implement setLastModified
    return Future.value(null);
  }

  @override
  void setLastModifiedSync(DateTime time) {
    // TODO: implement setLastModifiedSync
  }

  @override
  Future<FileStat> stat() {
    // TODO: implement stat
    return Future.value(null);
  }





  @override
  Future<File> writeAsBytes(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
    // TODO: implement writeAsBytes
    return Future.value(null);
  }

  @override
  void writeAsBytesSync(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
    // TODO: implement writeAsBytesSync
  }



  @override
  void writeAsStringSync(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    // TODO: implement writeAsStringSync
  }

  @override
  Stream<List<int>> openRead([int? start, int? end]) {
    // TODO: implement openRead
    throw UnimplementedError();
  }

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) {
    // TODO: implement openSync
    throw UnimplementedError();
  }

  @override
  IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) {
    // TODO: implement openWrite
    throw UnimplementedError();
  }

  @override
  Uint8List readAsBytesSync() {
    // TODO: implement readAsBytesSync
    throw UnimplementedError();
  }

  @override
  File renameSync(String newPath) {
    // TODO: implement renameSync
    throw UnimplementedError();
  }

  @override
  FileStat statSync() {
    // TODO: implement statSync
    throw UnimplementedError();
  }

  @override
  // TODO: implement uri
  Uri get uri => throw UnimplementedError();

  @override
  Stream<FileSystemEvent> watch({int events = FileSystemEvent.all, bool recursive = false}) {
    // TODO: implement watch
    throw UnimplementedError();
  }

  @override
  Future<File> writeAsString(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    // TODO: implement writeAsString
    throw UnimplementedError();
  }

}