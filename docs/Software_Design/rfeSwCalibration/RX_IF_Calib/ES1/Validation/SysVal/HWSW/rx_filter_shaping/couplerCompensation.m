function gainCompensation = couplerCompensation(freLO)

    switch freLO
        case 76e9
            gainCompensation  = 0.9;
        case 76.5e9
            gainCompensation = 0.9;
        case 77e9
            gainCompensation = 1;
        case 76.45e9
            gainCompensation = 0.9;
    
    end

end