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
