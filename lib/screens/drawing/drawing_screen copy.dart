// import 'package:canvas_drawing/models/story/frame_model.dart';
// import 'package:canvas_drawing/models/story/history_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:property_change_notifier/property_change_notifier.dart';

// import 'package:canvas_drawing/blocs/drawings/drawing_cubit.dart';
// import 'package:canvas_drawing/constants/draw_const.dart';
// import 'package:canvas_drawing/screens/drawing_tools/widgets/footer_bar.dart';
// import 'package:canvas_drawing/screens/drawing_tools/widgets/header_bar.dart';
// import 'package:canvas_drawing/widgets/painter/drawing_tool.dart';
// import 'package:canvas_drawing/widgets/painter/painter_controller.dart';

// class DrawingScreenArgument {
//   final DrawOrientation orientation;

//   DrawingScreenArgument(this.orientation);
// }

// class DrawingScreen extends StatefulWidget {
//   static String routeName = "/drawing-screen";

//   DrawingScreen({Key key}) : super(key: key);
//   @override
//   _DrawingScreenState createState() => _DrawingScreenState();
// }

// class _DrawingScreenState extends State<DrawingScreen> {
//   PainterController _controller;
//   @override
//   void initState() {
//     super.initState();

//     // TODO: move to Bloc
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {
//         _controller = _newController();
//       });
//     });
//   }

//   PainterController _newController() {
//     final state = BlocProvider.of<DrawingCubit>(context).state;
//     final FrameModel frame = state.frames[state.currentIndex];
//     PainterController controller = PainterController(frame.width, frame.height);
//     controller.thickness = 5.0;
//     controller.backgroundColor = Colors.white;

//     return controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Extract the arguments from the current ModalRoute settings and cast
//     // them as ScreenArguments.
//     // final DrawingBloc drawingBloc = BlocProvider.of<DrawingBloc>(context);
//     if (_controller == null) return Container();
//     final state = BlocProvider.of<DrawingCubit>(context).state;
//     final history = state.frames[state.currentIndex].history;

//     return Scaffold(
//       appBar: null,
//       body: SafeArea(
//         bottom: false,
//         child: PropertyChangeProvider(
//           value: _controller,
//           child: Container(
//             color: Colors.black.withOpacity(.44),
//             child: Stack(
//               children: [
//                 Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     bottom: 0,
//                     child: _buildDrawingTool(state, context)),
//                 HeaderBar(),
//                 FooterBar(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawingTool(DrawingState state, BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       child: DrawingTool(
//         this._controller,
//         state.drawOrientation == DrawOrientation.vertical
//             ? VerticalFrame(context)
//             : HorizontalFrame(context),
//       ),
//     );
//   }
// }
