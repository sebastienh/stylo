import Cocoa
import Common

var str = "Hello, playground"

var hashids1 = Hashids(salt:"stylesheet", minHashLength:8, alphabet:"abcdefghij1234567890");
var hash1 = hashids1.encode(0); // hash:"0825d856" stylo dark
var hash2 = hashids1.encode(1); // hash:"9je572gb" stylo light
var hash3 = hashids1.encode(2); // hash:"83258eg6" solarized dark
var hash4 = hashids1.encode(3); // hash:"b6d5e4g8" solarized light

var hashids2 = Hashids(salt:"style", minHashLength:8, alphabet:"abcdefghij1234567890");
var hash12 = hashids2.encode(0); // hash:"0825d856" stylo dark
var hash22 = hashids2.encode(1); // hash:"9je572gb" stylo light
var hash32 = hashids2.encode(2); // hash:"83258eg6" solarized dark
var hash42 = hashids2.encode(3); // hash:"b6d5e4g8" solarized light

var hashids3 = Hashids(salt:"source", minHashLength:8, alphabet:"abcdefghij1234567890");
var hash13 = hashids3.encode(0); // hash:"0825d856" stylo dark


