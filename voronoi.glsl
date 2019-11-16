float voronoi(const in vec2 pos, const in vec2 scale, const in float jitter, out vec2 tilePos, out vec2 relativePos)
{
    // voronoi based on Inigo Quilez implementation
    vec2 p = pos * floor(scale);
    vec2 i = floor(p);
    vec2 f = fract(p);

    // first pass
    vec2 minPos;
    float minDistance = 1e+5;
    for (int y=-1; y<=1; y++)
    {
        for (int x=-1; x<=1; x++)
        {
            vec2 n = vec2(float(x), float(y));
            vec2 cPos = hash2d(mod(i + n, scale)) * jitter;
            vec2 rPos = n + cPos - f;

            float d = dot(rPos, rPos);
            if(d < minDistance)
            {
                minDistance = d;
                minPos = rPos;
                tilePos = cPos;
            }
        }
    }
    relativePos = minPos;

    // second pass, distance to borders
    minDistance = 1e+5;
    for (int y=-2; y<=2; y++)
    {
        for (int x=-2; x<=2; x++)
        { 
            vec2 n = vec2(float(x), float(y));
            vec2 cPos = hash2d(mod(i + n, scale)) * jitter;
            vec2 rPos = n + cPos - f;
            
            vec2 v = minPos - rPos;
            if(dot(v, v) > 1e-5)
                minDistance = min(minDistance, dot( 0.5 * (minPos + rPos), normalize(rPos - minPos)));
        }
    }

    return minDistance;
}
