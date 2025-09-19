Music_PalletTown_Ch1::
        tempo 84
        volume 7, 7
        duty_cycle 0
        vibrato 12, 2, 6
        toggle_perfect_pitch
        note_type 12, 12, 7
.mainloop:
        rest 12
        octave 4
        note C#, 4
        rest 4
        note_type 12, 8, 3
        octave 3
        note G_, 8
        rest 4
        note B_, 4
        rest 8
        note_type 12, 12, 7
        octave 4
        note F_, 6
        rest 2
        note C#, 4
        rest 6
        note_type 12, 9, 2
        octave 2
        note F#, 8
        rest 8
        note_type 12, 12, 7
        octave 3
        note C_, 4
        rest 12
        sound_loop 0, .mainloop

        sound_ret ; unused

Music_PalletTown_Ch2::
        duty_cycle 2
        vibrato 8, 1, 5
        note_type 12, 10, 4
.mainloop:
        rest 8
        octave 5
        note G#, 4
        rest 4
        note F_, 4
        rest 8
        note_type 12, 7, 2
        octave 4
        note C#, 6
        rest 6
        octave 5
        note D_, 4
        rest 4
        note_type 12, 10, 4
        note C_, 4
        rest 8
        sound_loop 0, .mainloop

        sound_ret ; unused

Music_PalletTown_Ch3::
        vibrato 6, 1, 3
        note_type 12, 2, 6
.mainloop:
        rest 16
        octave 3
        note F#, 12
        rest 4
        note_type 12, 1, 7
        note B_, 8
        rest 8
        note_type 12, 2, 6
        octave 2
        note C#, 16
        rest 16
        sound_loop 0, .mainloop

        sound_ret ; unused
