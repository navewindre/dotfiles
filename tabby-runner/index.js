const cp = require('child_process');
const exec = cp.exec;
let child;

let killTabby = () => {
  exec( "ps aux | grep -E 'tabby'", ( error, stdout, stderr ) => {
    if( stdout ) {
      let lines = stdout.split( '\n' );
      for( let line of lines ) {
        let parts = line.split( /\s+/ );
        if( ( parts[10] === './tabby' || parts[10] == 'tabby' ) && parts[11] == 'serve' ) {
          cp.spawnSync( 'pkill', ['-P', parts[1]], { stdio: 'inherit' } );
          cp.spawnSync( 'kill', [parts[1]], { stdio: 'inherit' } );
          break;
        }
      }
    }
  } );
}


let loop = () => {
  exec( "ps aux | grep -E 'vim|nvim'", ( error, stdout, stderr ) => {
    if( stdout ) {
      console.log( stdout );
      let lines = stdout.split( '\n' );
      let vimOpen = false;
      for( let line of lines ) {
        let parts = line.split( /\s+/ );
        if( parts[10] === 'vim' || parts[10] === 'nvim' ) {
          vimOpen = true;
          break;
        }
      }
      if( vimOpen ) {
        if( child ) return setTimeout( loop, 120000 );
        child = cp.exec( `./run-client.sh`, ( error, stdout, stderr ) => {
          console.log( stdout );
        } );
        return setTimeout( loop, 5000 );
      }

      if( child ) {
        killTabby();
        child.kill();
      }

      child = null;
      setTimeout( loop, 5000 );
    } else {
      if( child ) {
        killTabby();
        child.kill();
        child = null;
      }

      setTimeout( loop, 5000 );
    }
  });

};

loop();
