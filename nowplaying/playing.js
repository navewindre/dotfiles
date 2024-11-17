#!/usr/bin/node

const WebSocket = require( "ws" );

process.on( "uncaughtException", () => {
  console.log();
} );

process.on( "unhandledRejection", () => {
  console.log();
} );

let ws = null;
let idc = 1;
const setupws = () => {
  try {
    ws = new WebSocket( "ws://localhost:7905" );
  } catch( e ) {

  }
  ws.onopen = () => {
    const obj = {
      name: "authenticate",
      type: "request",
      id: `msg-${idc++}`,
      options: {
        password: "1234"
      }
    }

    ws.send( JSON.stringify( obj ) );
  }
  ws.onmessage = ( e ) => {
    const parsed = JSON.parse( e.data );
    if( parsed.name == "authenticate" )
      return sendreq();

    const title = parsed.options.playing_track.title;
    let ret = ""
    if( parsed.options.state != 'playing' )
      ret = '(⏸) ';

    const artist = parsed.options.playing_track.artist;
    if( artist && artist.length > 0 ) {
      ret += artist;
      ret += ' - ';
    }

    const homedir = require( "os" ).homedir();
    if( title.startsWith( homedir ) ) {
      const path = title.substring( homedir.length + 1 );
      const file = path.split( "/" ).pop();
      ret += file;
    }
    else ret += title;
    if( ret.length > 30 )
      ret = ret.substring( 0, 30 ) + "...";
    console.log( ret );
    ws.close();
  };
}

const sendreq = () => {
  const obj = {
    name: "get_playback_overview",
    type: "request",
    id: `msg-${idc++}`,
    options: {
      password: "1234"
    }
  }

  ws.send( JSON.stringify( obj ) );
}

try {
  setupws();
} catch ( e ) {}
