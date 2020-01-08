declare name "midiSpat";
declare author "SCRIME";

import("stdfaust.lib");

N = 21; // Number of speaker pairs 

wina = (hslider("attack", 16, 0, 127, 1) / 127) * (5); // attack and release time;
winr = (hslider("release", 64, 0, 127, 1) / 127) * (10); // attack and release time;

input = nentry("input", 64, 0, 127, 1) / 100 : ba.lin2LogGain; // input volume slider;
sub = nentry("sub", 64, 0, 127, 1) / 127 : ba.lin2LogGain; // subwofer volume slider;

chan(i) = nentry("[%i]chan_%i", 0, 0, 127, 1) / 127: ba.lin2LogGain; // volume slider;

vcaChan(i) = en.asr(wina, 1, winr, chan(i));

demixer(n) = *(input) <: *(sub), *(sub),
*(vcaChan(0)), *(vcaChan(1)),
par( j, n-1, *(vcaChan(j+5)) );

process = demixer(N);

