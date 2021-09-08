import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final String title;
  final String url;
  final Function() onPressed;
  const CircularButton({
    Key? key,
    required this.title,
    required this.url,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Material(
            color: color.btnPrimaryColor,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/images/' + url),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(title, style: TextStyle(color: color.isDarkMode ? color.foreColor : color.foreColor, fontSize: 14, fontFamily: Strings.fSemiBold)),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function() onPressed;
  const PrimaryButton({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(title),
      onPressed: !isActive ? null : onPressed,
      style: ElevatedButton.styleFrom(
          onSurface: color.btnPrimaryColor,
          primary: color.btnPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          textStyle: TextStyle(fontSize: 15, fontFamily: Strings.fSemiBold)
      ),
    );
  }
}

class SuffixTextButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const SuffixTextButton({
    Key? key,
    required this.title,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        side: BorderSide(color: Colors.transparent, width: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Text(title, style: TextStyle(color: color.lightTextColor, fontSize: 14, fontFamily: Strings.fRegular)),
      ),
    );
  }
}

class ModalNetworkItem extends StatelessWidget {
  final String url;
  final String name;
  final bool selected;
  final Function() onPressed;
  const ModalNetworkItem({
    Key? key,
    required this.url,
    required this.name,
    required this.selected,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: OutlinedButton(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  imageUrl: url,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset('assets/images/coin.png'),
                ),
              ),
            ),
            Expanded(
                child: Text(name, style: TextStyle(color: color.foreColor, fontSize: 14, fontFamily: Strings.fMedium))
            ),
            Image.asset(selected ?  'assets/images/selected.png' : 'assets/images/unselected.png')
          ],
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          onSurface: Colors.brown,
          primary: color.borderColor,
          side: BorderSide(color:  color.borderColor, width: 2),
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ModalTokenItem extends StatelessWidget {
  final String url;
  final String name;
  final Function() onPressed;
  const ModalTokenItem({
    Key? key,
    required this.url,
    required this.name,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: OutlinedButton(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  imageUrl: url,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset('assets/images/coin.png'),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Text(name, style: TextStyle(color: color.foreColor, fontSize: 14, fontFamily: Strings.fMedium))
            ),
          ],
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          onSurface: Colors.brown,
          primary: color.borderColor,
          side: BorderSide(color:  color.borderColor, width: 2),
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

