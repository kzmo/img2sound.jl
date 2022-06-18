# img2sound.jl
A Julia script that converts image files to sound files with the image in the sound spectrum.

## Requirements

Tested with Julia 1.7.3.

Required packages:
- ArgParse
- Images
- SignalAnalysis
- Statistics
- WAV

## Running

Usage:
``` console
julia img2sound.jl [--sfreq SFREQ] [--size SIZE] [--linear]
                   [--randomphases] [--overlap OVERLAP] [-h]
                   inputfile
```
Positional arguments:
  - **inputfile**          Input image file to be converted.

Optional arguments:
  - **--sfreq SFREQ**      Sampling frequency in Hz. Default 44100. (type: Int64, default: 44100)
  - **--size SIZE**        Frequency resolution (FFT block size). Default 1024. (type: Int64, default: 1024)
  - **--linear**           Use a linear frequency scale instead of logarithmic.
  - **--randomphases**     Randomize phases.
  - **--overlap OVERLAP**  ISTFT block overlap. Defaults to 0.75 blocks (type: Float64, default: 0.75)
  - **-h**, **--help**         show this help message and exit

## Hints

The length of the generated sound file depends on the sampling frequency,
FFT block size and block overlap. It can be calculated by the formula:

``` console
Length in seconds = 2 * (FFT block size *  image horizontal resolution) * (1 - overlap) / sample rate
```

The higher the FFT block size the more vertical resolution there is.

If the sound starts pulsating you can try to increase the overlap.

Phase randomization can help with phase cancellation.
