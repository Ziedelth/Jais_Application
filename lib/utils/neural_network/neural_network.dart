import 'dart:math' as math;

import 'package:jais/utils/neural_network/matrix.dart';
import 'package:json_annotation/json_annotation.dart';

part 'neural_network.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class NeuralNetwork {
  static final Func sigmoid = Func('sigmoid', (num e, int i, int j) => 1 / (1 + math.exp(-e)), (num e, int i, int j) => e * (1 - e));
  static final Func tanh = Func('tanh', (num e, int i, int j) => math.atan(e), (num e, int i, int j) => 1 - (e * e));
  static final Func relu = Func('relu', (num e, int i, int j) => e > 0 ? e : 0, (num e, int i, int j) => e > 0 ? 1 : 0);

  static Func getFuncByName(String name) {
    switch (name) {
      case 'sigmoid':
        return sigmoid;
      case 'tanh':
        return tanh;
      case 'relu':
        return relu;
      default:
        return sigmoid;
    }
  }

  final int inputs;
  final int hidden;
  final int outputs;
  late final Matrix weightsIh;
  late final Matrix weightsHo;
  late final Matrix biasH;
  late final Matrix biasO;
  double learningRate = 0.1;
  String func = 'sigmoid';

  NeuralNetwork(this.inputs, this.hidden, this.outputs) {
    weightsIh = Matrix(hidden, inputs)..randomize();
    weightsHo = Matrix(outputs, hidden)..randomize();
    biasH = Matrix(hidden, 1)..randomize();
    biasO = Matrix(outputs, 1)..randomize();
  }

  factory NeuralNetwork.fromJson(Map<String, dynamic> data) => _$NeuralNetworkFromJson(data);

  Map<String, dynamic> toJson() => _$NeuralNetworkToJson(this);

  List<num> predict(List<num> inputs) {
    final Matrix inputsMatrix = Matrix.fromList1D(inputs);
    final Matrix hidden = Matrix.multiply(weightsIh, inputsMatrix)..add(biasH)..map(getFuncByName(func).function);
    final Matrix output = Matrix.multiply(weightsHo, hidden)..add(biasO)..map(getFuncByName(func).function);
    return output.toList1D();
  }

  void train(List<num> inputs, List<num> outputs) {
    final Matrix inputsMatrix = Matrix.fromList1D(inputs);
    final Matrix hidden = Matrix.multiply(weightsIh, inputsMatrix)..add(biasH)..map(getFuncByName(func).function);
    final Matrix output = Matrix.multiply(weightsHo, hidden)..add(biasO)..map(getFuncByName(func).function);
    final Matrix outputError = Matrix.fromList1D(outputs)..subtract(output);
    final Matrix gradients = Matrix.map(output, getFuncByName(func).dFunction)..multiply(outputError)..multiplyScalar(learningRate);
    final Matrix hiddenT = Matrix.transpose(hidden);
    final Matrix weightsHoDelta = Matrix.multiply(gradients, hiddenT);
    biasO.add(gradients);
    weightsHo.add(weightsHoDelta);
    final Matrix whoT = Matrix.transpose(weightsHo);
    final Matrix hiddenError = Matrix.multiply(whoT, outputError);
    final Matrix hiddenGradients = Matrix.map(hidden, getFuncByName(func).dFunction)..multiply(hiddenError)..multiplyScalar(learningRate);
    final Matrix inputsT = Matrix.transpose(inputsMatrix);
    final Matrix weightsIhDelta = Matrix.multiply(hiddenGradients, inputsT);
    biasH.add(hiddenGradients);
    weightsIh.add(weightsIhDelta);
  }
}

class Func {
  final String name;
  final num Function(num e, int i, int j) function;
  final num Function(num e, int i, int j) dFunction;

  Func(this.name, this.function, this.dFunction);
}
