import QtQuick 2.0
import Score 1.0
Item {
  // Les E/S de la boite
  IntSlider  { id: velocity; min: 0; max: 127; init: 64 }
  MidiInlet  { id: midiIn }
  MidiOutlet { id: midiOut }

  // Fonctions utilitaires
  function clamp(value, min, max)
  { return Math.min(Math.max(value, min), max); }

  function getMessageType(message)
  {
    var fb = message[0];
    if(fb >= 0xF0)
      return fb & 0xFF;
    else
      return fb & 0xF0;
  }

  function isNoteOff(message)
  { return getMessageType(message) == 0x80; }
  function isNoteOn(message)
  { return getMessageType(message) == 0x90; }
  function isPressure(message)
  { return getMessageType(message) == 0xA0; }
  function isCC(message)
  { return getMessageType(message) == 0xB0; }
  function isPC(message)
  { return getMessageType(message) == 0xC0; }
  function isAftertouch(message)
  { return getMessageType(message) == 0xD0; }
  function isPitchBend(message)
  { return getMessageType(message) == 0xE0; }

  function getChannel(data)
  {
    if ((data[0] & 0xF0) != 0xF0)
      return (data[0] & 0xF) + 1;
    return 0;
  }

  function getVelocity(note_message)
  { return note_message[2]; }
  function setVelocity(note_message, vel)
  { note_message[2] = clamp(vel, 0, 127); }
  
  function off2on0(note_message)
  {
    note_message[0] = 0x90;
    note_message[2] = 0;
  }

  // Cette fonction est appelée à chaque tick.
  function onTick(oldtime, time, position, offset)
  {
    var messages = midiIn.messages();
    for(var i = 0; i < messages.length; ++i)
    {
    var message = messages[i];
      
    if(isNoteOn(message))
    {
       setVelocity(message, getVelocity(message) + velocity.value);
    } 
    else if(isNoteOff(message))
    {
        off2on0(message);
    }

    midiOut.add(message);        
    }
    }
  }
