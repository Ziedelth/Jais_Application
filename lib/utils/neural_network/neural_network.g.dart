// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neural_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeuralNetwork _$NeuralNetworkFromJson(Map<String, dynamic> json) =>
    NeuralNetwork(
      json['inputs'] as int,
      json['hidden'] as int,
      json['outputs'] as int,
    )
      ..weightsIh = Matrix.fromJson(json['weights_ih'] as Map<String, dynamic>)
      ..weightsHo = Matrix.fromJson(json['weights_ho'] as Map<String, dynamic>)
      ..biasH = Matrix.fromJson(json['bias_h'] as Map<String, dynamic>)
      ..biasO = Matrix.fromJson(json['bias_o'] as Map<String, dynamic>)
      ..learningRate = (json['learning_rate'] as num).toDouble()
      ..func = json['func'] as String;

Map<String, dynamic> _$NeuralNetworkToJson(NeuralNetwork instance) =>
    <String, dynamic>{
      'inputs': instance.inputs,
      'hidden': instance.hidden,
      'outputs': instance.outputs,
      'weights_ih': instance.weightsIh.toJson(),
      'weights_ho': instance.weightsHo.toJson(),
      'bias_h': instance.biasH.toJson(),
      'bias_o': instance.biasO.toJson(),
      'learning_rate': instance.learningRate,
      'func': instance.func,
    };
