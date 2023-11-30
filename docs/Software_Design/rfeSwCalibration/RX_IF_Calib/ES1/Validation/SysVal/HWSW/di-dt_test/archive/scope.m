function Untitled()

% Variable declarations

% Connect steps
DSOS804A = tcpip('169.254.165.53', 5025);
DSOS804A.InputBufferSize = 8388608;
DSOS804A.ByteOrder = 'littleEndian';
fopen(DSOS804A);

% Commands
fprintf(DSOS804A, sprintf(':SYST:PRES %s', 'DEF'));
fprintf(DSOS804A, sprintf(':ACQ:SRAT %s', 'AUTO'));
fprintf(DSOS804A, sprintf(':CHAN2:DISP %d', 1));
fprintf(DSOS804A, sprintf(':CHAN1:DISP %d', 1));
fprintf(DSOS804A, sprintf(':CHAN3:DISP %d', 1));
fprintf(DSOS804A, sprintf(':CHAN4:DISP %d', 1));
fprintf(DSOS804A, sprintf(':CHAN1:OFFS %g', -0.22));
fprintf(DSOS804A, sprintf(':CHAN2:OFFS %g', -1.1));
fprintf(DSOS804A, sprintf(':CHAN3:OFFS %g', 1.0));
fprintf(DSOS804A, sprintf(':CHAN4:OFFS %g', 1.76));
fprintf(DSOS804A, sprintf(':CHAN1:SCAL %g', 1.0));
fprintf(DSOS804A, sprintf(':CHAN2:SCAL %g', 1.0));
fprintf(DSOS804A, sprintf(':CHAN3:SCAL %g', 1.0));
fprintf(DSOS804A, sprintf(':CHAN4:SCAL %g', 0.5));
fprintf(DSOS804A, sprintf(':TRIG:MODE %s', 'EDGE'));
fprintf(DSOS804A, sprintf(':TRIG:LEV %s,%g', 'CHAN3', 0.52));
fprintf(DSOS804A, sprintf(':TRIG:EDGE:SLOP %s', 'POS'));
fprintf(DSOS804A, sprintf(':TRIG:EDGE:SOUR %s', 'CHAN3'));
fprintf(DSOS804A, sprintf(':TIM:SCAL %g', 0.02));
fprintf(DSOS804A, sprintf(':TIM:POS %g', 0.07945));
fprintf(DSOS804A, sprintf(':ACQ:MODE %s', 'RTIM'));
fprintf(DSOS804A, sprintf(':TRIG:SWE %s', 'TRIG'));

% Cleanup
fclose(DSOS804A);
delete(DSOS804A);
clear DSOS804A;

end
