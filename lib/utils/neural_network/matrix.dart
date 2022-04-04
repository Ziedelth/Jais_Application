import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'matrix.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Matrix {
  final int rows;
  final int cols;
  late final List<List<num>> matrix;

  Matrix(this.rows, this.cols) {
    matrix = List.generate(rows, (_) => List.generate(cols, (_) => 0));
  }

  factory Matrix.fromJson(Map<String, dynamic> data) => _$MatrixFromJson(data);

  Map<String, dynamic> toJson() => _$MatrixToJson(this);

  factory Matrix.map(
    Matrix matrix,
    num Function(num e, int i, int j) function,
  ) =>
      Matrix(matrix.rows, matrix.cols)..map(function);

  factory Matrix.fromList1D(List<num> list) =>
      Matrix(list.length, 1).map((_, i, j) => list[j]);

  factory Matrix.subtract(Matrix a, Matrix b) =>
      Matrix(a.rows, a.cols).map((e, i, j) => a.matrix[i][j] - b.matrix[i][j]);

  factory Matrix.transpose(Matrix a) =>
      Matrix(a.cols, a.rows).map((e, i, j) => a.matrix[j][i]);

  factory Matrix.multiply(Matrix a, Matrix b) =>
      Matrix(a.rows, b.cols).map((e, i, j) {
        num sum = 0;
        for (var k = 0; k < a.cols; k++) {
          sum += a.matrix[i][k] * b.matrix[k][j];
        }
        return sum;
      });

  Matrix map(num Function(num e, int i, int j) function) {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        matrix[i][j] = function(matrix[i][j], i, j);
      }
    }

    return this;
  }

  Matrix copy() => Matrix.map(this, (e, i, j) => e);

  List<num> toList1D() =>
      List.generate(rows * cols, (i) => matrix[i ~/ cols][i % cols]);

  Matrix randomize() => map((e, i, j) => Random().nextDouble() * 2 - 1);

  Matrix add(Matrix other) =>
      Matrix.map(this, (e, i, j) => e + other.matrix[i][j]);

  Matrix addScalar(num scalar) => map((e, i, j) => e + scalar);

  Matrix subtract(Matrix other) =>
      Matrix.map(this, (e, i, j) => e - other.matrix[i][j]);

  Matrix subtractScalar(num scalar) => map((e, i, j) => e - scalar);

  Matrix multiply(Matrix other) =>
      Matrix.map(this, (e, i, j) => e * other.matrix[i][j]);

  Matrix multiplyScalar(num scalar) => map((e, i, j) => e * scalar);
}
