import numpy as np
import wave

def save_wav(filename, signal, sample_rate=44100):
    # Normieren auf 16-bit PCM
    signal = np.int16(signal / np.max(np.abs(signal)) * 32767)
    with wave.open(filename, 'w') as f:
        f.setnchannels(1)       # Mono
        f.setsampwidth(2)       # 16-bit
        f.setframerate(sample_rate)
        f.writeframes(signal.tobytes())

sample_rate = 44100
duration = 1.2
t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)

# Tiefer Bass (sub-bass Gefühl)
bass = 0.6 * np.sin(2 * np.pi * 70 * t)

# Subbass mit leichtem Pulsieren
sub = 0.4 * np.sin(2 * np.pi * (40 + 5*np.sin(2*np.pi*1*t)) * t)

# Whoosh: leichtes Rauschen + Sweep
noise = np.random.normal(0, 1, len(t)) * (1 - t/duration) * 0.15
whoosh = np.sin(2 * np.pi * (150 + 200*t) * t) * 0.2

# Mystische Obertöne
overtones = 0.1 * np.sin(2 * np.pi * 400 * t) * np.exp(-4*t)

# Alles zusammen
signal = bass + sub + whoosh + noise + overtones

# Hüllkurve: schneller Attack, langsames Decay
envelope = np.exp(-2 * t)
signal *= envelope

# Speichern
save_wav("moon_gain_ds1.wav", signal, sample_rate)
print("✅ Sound gespeichert als moon_gain_ds1.wav")

