#pragma once

#include "ofxiOS.h"
#include "ofxOsc.h"

#define HOST "192.168.0.8"
#define PORT 1234

#define NUM_MSG_STRINGS 20

class ofApp : public ofxiOSApp {

	public:
		void setup();
		void update();
		void draw();
		void exit();
		
		void touchDown(ofTouchEventArgs & touch);
		void touchMoved(ofTouchEventArgs & touch);
		void touchUp(ofTouchEventArgs & touch);
		void touchDoubleTap(ofTouchEventArgs & touch);
		void touchCancelled(ofTouchEventArgs & touch);

		void lostFocus();
		void gotFocus();
		void gotMemoryWarning();
		void deviceOrientationChanged(int newOrientation);

		ofxOscSender sender;
    
        ofBuffer imgAsBuffer;
        ofImage img;
    
    ///
    ofxOscReceiver receiver;
    ofImage receivedImage;
    
    int current_msg_string;
    string msg_strings[NUM_MSG_STRINGS];
    float timers[NUM_MSG_STRINGS];

    int mouseX;
    int mouseY;
    string mouseButtonState;
};

