import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  bool? isBottom;
  Color? btnColor;
  Color? highlightColor;
  VoidCallback? ontap;
  String? btnName;
  DefaultButton(
      {Key? key,
      this.btnColor,
      this.btnName,
      this.highlightColor,
      this.isBottom,
      this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(
          top: 10, right: 10, left: 10, bottom: isBottom! ? 10 : 0),
      decoration: BoxDecoration(
          color: btnColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [btnColor!, btnColor!.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: ontap,
          splashColor: btnColor!.withOpacity(0.75),
          highlightColor: highlightColor!.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        btnName!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
