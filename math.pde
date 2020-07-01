public float byteArrayToFloat(byte test[]) { 
    int MASK = 0xff; 
    int bits = 0; 
    int i = 3; 
    for (int shifter = 3; shifter >= 0; shifter--) { 
    bits |= ((int) test[i] & MASK) << (shifter * 8); 
    i--; 
    } 
    return Float.intBitsToFloat(bits); 
} // Credit for conversion script cadomanis of the Processing Forum. 

int b2i(byte[] from, int offs) {
  return ( from[offs    ] & 0xff       ) |
         ((from[offs + 1] & 0xff) <<  8) |
         ((from[offs + 2] & 0xff) << 16) |
         ((from[offs + 3] & 0xff) << 24);
} // this one subpixel of the Processing Forum.
