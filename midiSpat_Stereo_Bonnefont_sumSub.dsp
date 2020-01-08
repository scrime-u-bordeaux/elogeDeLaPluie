declare name "midiSpat";
declare author "SCRIME";

import("stdfaust.lib");

N = 11; // Number of speaker pairs 

wina = (hslider("attack", 16, 0, 127, 1) / 127) *(5); // attack and release time;
winr = (hslider("release", 64, 0, 127, 1) / 127) *(10); // attack and release time;

input = nentry("input", 64, 0, 127, 1) / 100 : ba.lin2LogGain; // input volume slider;
sub = nentry("sub", 64, 0, 127, 1) / 127 : ba.lin2LogGain: /(N - 2); // subwofer volume slider;

chan(i) = nentry("[(%i]chan_%i", 0, 0, 127, 1) / 127: ba.lin2LogGain; // left volume slider;

vcaChan(i) = en.asr(wina, 1, winr, chan(i));

demixer(n) = *(input), *(input) <: *(vcaChan(0)), *(vcaChan(1)), // headphones
  (par( j, n-1, *(vcaChan((j*2)+5)), *(vcaChan((j*2)+6))) <: (par( j, n-1, _,_) :> *(sub), *(sub)), (par( j, n-1, _,_)));

process = demixer(N);
