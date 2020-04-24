#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	ofSetOrientation(OF_ORIENTATION_90_LEFT);

	ofBackground( 40, 100, 40 );

	// open an outgoing connection to HOST:PORT
	sender.setup( HOST, PORT );
    
    imgAsBuffer = ofBufferFromFile("forge.jpg", true);
    
    //
    receiver.setup(PORT);
    current_msg_string = 0;
    mouseX = 0;
    mouseY = 0;
    mouseButtonState = "";
}

//--------------------------------------------------------------
void ofApp::update(){
	//we do a heartbeat on iOS as the phone will shut down the network connection to save power
	//this keeps the network alive as it thinks it is being used. 
	if( ofGetFrameNum() % 120 == 0 ){
		ofxOscMessage m;
		m.setAddress( "/misc/heartbeat" );
		m.addIntArg( ofGetFrameNum() );
		sender.sendMessage( m );
	}
    
    ///
    while( receiver.hasWaitingMessages() ){
        // get the next message
        ofxOscMessage m;
        receiver.getNextMessage(m);

        // check for mouse moved message
        if( m.getAddress() == "/mouse/position" ){
            // both the arguments are int32's
            mouseX = m.getArgAsInt32( 0 );
            mouseY = m.getArgAsInt32( 1 );
        }
        // check for mouse button message
        else if( m.getAddress() == "/mouse/button" ){
            // the single argument is a string
            mouseButtonState = m.getArgAsString( 0 ) ;
        }
        else if (m.getAddress() == "/image"){
            ofBuffer buffer = m.getArgAsBlob(0);
            receivedImage.load(buffer);
        }
        
        else{
            // unrecognized message: display on the bottom of the screen
            string msg_string;
            msg_string = m.getAddress();
            msg_string += ": ";
            for( int i=0; i<m.getNumArgs(); i++ ){
                // get the argument type
                msg_string += m.getArgTypeName( i );
                msg_string += ":";
                // display the argument - make sure we get the right type
                if( m.getArgType( i ) == OFXOSC_TYPE_INT32 )
                    msg_string += ofToString( m.getArgAsInt32( i ) );
                else if( m.getArgType( i ) == OFXOSC_TYPE_FLOAT )
                    msg_string += ofToString( m.getArgAsFloat( i ) );
                else if( m.getArgType( i ) == OFXOSC_TYPE_STRING )
                    msg_string += m.getArgAsString( i );
                else
                    msg_string += "unknown";
            }
            // add to the list of strings to display
            msg_strings[current_msg_string] = msg_string;
            timers[current_msg_string] = ofGetElapsedTimef() + 5.0f;
            current_msg_string = ( current_msg_string + 1 ) % NUM_MSG_STRINGS;
            // clear the next line
            msg_strings[current_msg_string] = "";
        }
    }    
}

//--------------------------------------------------------------
void ofApp::draw(){
	// display instructions
	string buf;
	buf = "sending osc messages to" + string( HOST ) + ofToString( PORT );
	ofDrawBitmapString( buf, 10, 20 );
	ofDrawBitmapString( "move the mouse to send osc message [/mouse/position <x> <y>]", 10, 50 );
    
    if(img.getWidth() > 0){
        img.draw(0, 0);
    }
    
    ///
    if(receivedImage.getWidth() > 0){
        ofDrawBitmapString("Image:", 10, 160);
        receivedImage.draw(10,10);
        receivedImage.save("receImage.jpg");
    }
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
	ofxOscMessage m;
//	m.setAddress( "/mouse/button" );
//	m.addStringArg( "down" );
//	sender.sendMessage( m );
    
    m.setAddress("/image");
    m.addBlobArg(imgAsBuffer);
    sender.sendMessage(m);
    
    cout << "sending image with size: " << imgAsBuffer.size() << endl;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
	ofxOscMessage m;
	m.setAddress( "/mouse/position" );
	m.addIntArg( touch.x );
	m.addIntArg( touch.y );
	sender.sendMessage( m );
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
	ofxOscMessage m;
	m.setAddress( "/mouse/button" );
	m.addStringArg( "up" );
	sender.sendMessage( m );
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
