
var emulated = haxe.io.ArrayBufferView.EMULATED;

#if js
if( untyped js.html.Float64Array == "notsupported" ) return;
#end

var b = new haxe.io.Float64Array(5);
b[0] == 0;
b[4] == 0;
b.length == 5;

// check float write
b[1] = 1.25;
b[1] == 1.25;

// set
for( i in 0...5 )
	b[i] = i + 1;
b[0] == 1;
b[4] == 5;

// access outside bounds is unspecified but should not crash
try b[-1] catch( e : Dynamic ) {};
try b[5] catch(e : Dynamic) {};

// same for writing
try b[-1] = 55 catch( e : Dynamic ) {};
try b[5] = 55 catch(e : Dynamic) {};

var b2 = b.sub(1,3);
b2[0] == 2;
b2[2] == 4;
b2.length == 3;

// check memory sharing
if( !emulated ) {
	b2[0] = 0xCC;
	b2[0] == 0xCC;
	b[1] == 0xCC;
}

// should we allow writing past bounds ?
try b2[-1] = 0xBB catch( e : Dynamic ) {};
b[0] == 1;

try b2[3] = 0xBB catch( e : Dynamic ) {};
b[4] == 5;


b.view == b.view; // no alloc

if( !emulated ) b.view.buffer == b2.view.buffer;
b.view.byteLength == 40;
b.view.byteOffset == 0;
b2.view.byteLength == 24;
b2.view.byteOffset == 8;

// check sub
var sub = b.sub(1);
sub.length == b.length - 1;
sub[0] == (emulated ? 2 : 0xCC);
sub[0] = 0xDD;
if( !emulated ) b[1] == 0xDD;

var sub = b.subarray(2,3);
sub.length == 1;
sub[0] == 3;
sub[0] = 0xEE;
if( !emulated ) b[2] == 0xEE;

// from bytes
var b3 = haxe.io.Float64Array.fromBytes(b.view.buffer, 2*8, 3);
b3.length == 3;
for( i in 0...3 )
	b3[i] == b[i+2];
b3[0] = b[3] + 1;
if( !emulated ) b3[0] == b[2];
