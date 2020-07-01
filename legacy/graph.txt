float getMin(DataPoint[] data, String value) {
  float min = Float.POSITIVE_INFINITY;
  for(int i = 0; i < data.length; i++) {
    if(data[i].getValue(value) < min) { min = data[i].getValue(value); }
  }
  return min;
}
float getMax(DataPoint[] data, String value) {
  float max = Float.NEGATIVE_INFINITY;
  for(int i = 0; i < data.length; i++) {
    if(data[i].getValue(value) > max) { max = data[i].getValue(value); }
  }
  return max;
}


void graph(int x, int y, int w, int h, DataPoint[] data, String haxis, String vaxis) {
  if(data.length > 0) {
    float minH = getMin(data, haxis);
    float minV = getMin(data, vaxis);
    float maxH = getMax(data, haxis);
    float maxV = getMax(data, vaxis);
    
    for(int i = 0; i < data.length-1; i++) {
      line(map(data[i  ].getValue(haxis), minH, maxH, 0, w),
           map(data[i  ].getValue(vaxis), minV, maxV, 0, h),
           map(data[i+1].getValue(haxis), minH, maxH, 0, w),
           map(data[i+1].getValue(vaxis), minV, maxV, 0, h));
    }
  }
}
