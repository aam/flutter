// Copyright 2018 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pictures',
        theme: new ThemeData(),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}): super(key: key);

  @override _MyHomePageState createState() => new _MyHomePageState();
}

const List<List<String>> allImages = <List<String>> [
  <String> [
    'https://lh5.googleusercontent.com/p/AF1QipMfJkCqwsFZ1tvroJAeqrSD-8EMlJbsQ45QVxLW=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOLPYoJqwzT0nMrSrl7r9M90f9QUswPn0KPaVPt=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOEIyRE226aH2DQfCxcWyAMKTj5f_sIbcuxl8O9=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMqPXCIuEbY9DKochpOZylTSehBGcB8MtejkKfG=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMcZXUD2MA9wrMXmVMLpOKID397SCv2u3HqDSWe=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipNdQ2-4cjG_GK64rvbqYDpOueE2zl2Sf216w3GY=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipO5O04KVVwZQNtmf47Zhwblxx3QxB6snrCndefg=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipP5wk0lMCp8DtcFJfMovj8rYU088LNLGNeIDr90=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPAQ4FDhOq7_PbmJwrCpEejPS5z6n9xcPQ8YmjU=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM0RHYSzAIg34N8XR7sLfP4hWKQd_voxnKjCFsm=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMSZ6qZ47v5aQpaOLUxZYR3_Oo4z6yduVRPNyLg=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOT36DHUJtLS3ORlVrQ2utV0rHGBB-dphQ3Qhei=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM2XW3TaKpNOqDiu0es_fDnK1p7JMXwsH62-SuI=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipNqysPtu1-hqk_-vkeXxgz7uV9Z56YqKIQ92fTI=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOQaqxjPakpqYs4yC94K4E39vgpYFVEMXuafooS=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM9QxYuXkfQUG76lccBrrMfEPSr1OMiZRPhagUC=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPAQ4FDhOq7_PbmJwrCpEejPS5z6n9xcPQ8YmjU=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM0RHYSzAIg34N8XR7sLfP4hWKQd_voxnKjCFsm=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPXc0LFkuQyWFkr0HrgpMx21zkm7YgUHUbQlbzz=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPEiODt4Sj3Y10JCwh9g1HQV9NTLzVjE_YkuYQO=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMsnGOt_evqNCckbdAEVWldaravAcs-UIVlR30J=w960-h1440-n-k-no',
//    'https://lh5.googleusercontent.com/p/AF1QipOPPbPjKwIfxtsXUF6OOe-aN72n26RNsE85ve0T=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPWrOrVZ2KsvqaKV2fQg78y6xVxN15z1F1xEaeD=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPOCNBp_79u81mBWXUHP6ecEB26-u61d3nA-EhO=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMOGtfN2-NlMSIrGnvdEdtUwEUixfn65nZ1GzC_=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMXD-KNPBT_vA5cKBMxYS1eFkKfJoYrCrj6FxYA=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMnqZzsRae9cZEaN4C37Chtbzg7XNyqjv7RfU5Y=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM61enjbe4KolQU30uwosonZ1LQ_xk0dJ9Ai8RI=w960-h1440-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOLPYoJqwzT0nMrSrl7r9M90f9QUswPn0KPaVPt=w960-h1440-n-k-no',
  ],
  <String> [
    'https://lh5.googleusercontent.com/p/AF1QipMfJkCqwsFZ1tvroJAeqrSD-8EMlJbsQ45QVxLW=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOLPYoJqwzT0nMrSrl7r9M90f9QUswPn0KPaVPt=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOEIyRE226aH2DQfCxcWyAMKTj5f_sIbcuxl8O9=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMqPXCIuEbY9DKochpOZylTSehBGcB8MtejkKfG=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMcZXUD2MA9wrMXmVMLpOKID397SCv2u3HqDSWe=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipNdQ2-4cjG_GK64rvbqYDpOueE2zl2Sf216w3GY=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipO5O04KVVwZQNtmf47Zhwblxx3QxB6snrCndefg=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipP5wk0lMCp8DtcFJfMovj8rYU088LNLGNeIDr90=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPAQ4FDhOq7_PbmJwrCpEejPS5z6n9xcPQ8YmjU=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM0RHYSzAIg34N8XR7sLfP4hWKQd_voxnKjCFsm=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMSZ6qZ47v5aQpaOLUxZYR3_Oo4z6yduVRPNyLg=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOT36DHUJtLS3ORlVrQ2utV0rHGBB-dphQ3Qhei=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM2XW3TaKpNOqDiu0es_fDnK1p7JMXwsH62-SuI=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipNqysPtu1-hqk_-vkeXxgz7uV9Z56YqKIQ92fTI=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOQaqxjPakpqYs4yC94K4E39vgpYFVEMXuafooS=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM9QxYuXkfQUG76lccBrrMfEPSr1OMiZRPhagUC=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPAQ4FDhOq7_PbmJwrCpEejPS5z6n9xcPQ8YmjU=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM0RHYSzAIg34N8XR7sLfP4hWKQd_voxnKjCFsm=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPXc0LFkuQyWFkr0HrgpMx21zkm7YgUHUbQlbzz=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPEiODt4Sj3Y10JCwh9g1HQV9NTLzVjE_YkuYQO=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMsnGOt_evqNCckbdAEVWldaravAcs-UIVlR30J=w1440-h960-n-k-no',
//    'https://lh5.googleusercontent.com/p/AF1QipOPPbPjKwIfxtsXUF6OOe-aN72n26RNsE85ve0T=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPWrOrVZ2KsvqaKV2fQg78y6xVxN15z1F1xEaeD=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipPOCNBp_79u81mBWXUHP6ecEB26-u61d3nA-EhO=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMOGtfN2-NlMSIrGnvdEdtUwEUixfn65nZ1GzC_=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMXD-KNPBT_vA5cKBMxYS1eFkKfJoYrCrj6FxYA=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipMnqZzsRae9cZEaN4C37Chtbzg7XNyqjv7RfU5Y=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipM61enjbe4KolQU30uwosonZ1LQ_xk0dJ9Ai8RI=w1440-h960-n-k-no',
    'https://lh5.googleusercontent.com/p/AF1QipOLPYoJqwzT0nMrSrl7r9M90f9QUswPn0KPaVPt=w1440-h960-n-k-no',
  ],
]
;

class _MyHomePageState extends State<MyHomePage> {
  List<String> imageSrcs;
  int state = 0;
  Random random = Random(DateTime.now().millisecondsSinceEpoch);

  _MyHomePageState() {
    refreshImages();
  }

  void refreshImages() {
//    int start = random.nextInt(allImages.length);
//    imageSrcs = allImages.getRange(start, start + random.nextInt(allImages.length - start)).toList();
    imageSrcs = allImages[state].getRange(0, allImages[state].length).toList();
    state = 1 - state;
  }

  String getId(int i) {
    String uriString = imageSrcs[i];
    int eqIndex = uriString.indexOf('=');
    if (eqIndex != -1) {
      return uriString.substring(eqIndex - 3, eqIndex);
    } else {
      return '$uriString...$eqIndex';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Pictures'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 80.0, right: 80.0),
        child: new ListView.builder(
          itemCount: imageSrcs.length,
          itemBuilder: (ctx, i) =>
              Container(
                decoration:
                BoxDecoration(border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Row(
                    children: <Widget>[
                      Text(getId(i)),
                      Flexible(
                        child: SizedBox(
                          child: Image(
                            image: new NetworkImage(imageSrcs[i]),
                          ),
                          width: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => setState(refreshImages),
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}