function power_cycle
    instrreset;
    % Variable declarations

    % Connect steps
    E3631A = visa('agilent', 'GPIB1::6::INSTR');
    E3631A.InputBufferSize = 8388608;
    E3631A.ByteOrder = 'littleEndian';
    fopen(E3631A);

    % Commands
    fprintf(E3631A, sprintf(':OUTP %d', 0));
    pause(2);
    fprintf(E3631A, sprintf(':OUTP %d', 1));
    pause(2)

    % fprintf(E3631A, sprintf(':OUTP %d,(%s)', 0, '@1'));
    % pause(2)
    % fprintf(E3631A, sprintf(':OUTP %d,(%s)', 1, '@1'));
    % pause(2)

    % Cleanup
    fclose(E3631A);
    delete(E3631A);
    clear E3631A;

end
