"""
img2sound.jl

Synopsis: Converts an image file to a WAV file using Short-Time FFT

Author: Janne Valtanen (janne.valtanen@infowader.com)
"""

using ArgParse
using Images
using SignalAnalysis
using Statistics
using WAV

s = ArgParseSettings(description="Converts an image file to a WAV file using Short-Time FFT")

@add_arg_table s begin
    "inputfile"
        help = "Input image file to be converted."
        arg_type = String
        required = true
    "--sfreq"
        arg_type = Int
        default = 44100
        help = "Sampling frequency in Hz. Default 44100."
    "--size"
        arg_type = Int
        default = 1024
        help = "Frequency resolution (FFT block size). Default 1024."
    "--linear"
        action = :store_true
        help = "Use a linear frequency scale instead of logarithmic."
    "--randomphases"
        action = :store_true
        help = "Randomize phases."
    "--overlap"
        arg_type = Float64
        default = 0.75
        help = "ISTFT block overlap. Defaults to 0.75 blocks."
end

args = parse_args(s)

# Get the arguments
filename = args["inputfile"]
sfreq = args["sfreq"]
nperseg = args["size"]
overlap = args["overlap"]

# Load the image, convert to grayscale and into an array
println("Loading: " * filename)
rgb_image = load(filename)
image = Gray.(rgb_image)
image_data = convert(Array{Float64}, image)

println("Converting image to sound!")

# Flip the image upside down so that row 0 is the frequency at index 0
image_data = reverse(image_data, dims=1)

# Short Time FFT data table
stft_data = zeros(ComplexF64, nperseg + 1, size(image_data, 2))

if !args["linear"]
    # Logarithmic frequency scale
    base = 2 # The base for logarithmic frequency scale
    freq_min = 10 # Minimum frequency for logarithmic frequency scale

    # Conversion table from pixel y-coordinate to the frequency
    conv_table = trunc.(Int64, base.^(range(log(base, freq_min),
                                            stop=log(base, nperseg),
                                            length=size(image_data, 1))))
else
    # Linear frequency scale
    # Conversion table from pixel y-coordinate to the frequency
    conv_table = trunc.(Int64, range(1,
                                     stop=nperseg,
                                     length=size(image_data, 1)))
end

# Copy the values from the image to the corresponding STFT values based
# on the conversion table
for line_nr ∈ 1:size(stft_data, 2)
    line = image_data[:, line_nr]
    for y ∈ 1:size(line, 1)
        stft_data[conv_table[y], line_nr] = line[y]
    end
end

if args["randomphases"]
    # Randomize phases
    phases = (2 * π) .* rand(size(stft_data)...)
    factors = exp.(1im * phases)
    stft_data = stft_data .* factors
end

# Do the Inverse Short-time FFT
sound_data = istft(Real, stft_data; nfft=nperseg * 2,
                   noverlap=Int64(round(2 * nperseg * overlap)),
                   window=hanning)

# Remove the DC level
dc_level = mean(sound_data)
sound_data = sound_data.-dc_level

# Normalize
max_level = maximum(abs.(sound_data))
sound_data = sound_data./max_level

# Write to WAV-file
outfile = filename * ".wav"
println("Writing to: " * outfile)
wavwrite(sound_data, outfile, Fs=sfreq)
