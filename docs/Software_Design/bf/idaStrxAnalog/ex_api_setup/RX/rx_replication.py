import re
import IPython


file_list = 'idaSTRX_RX1_off2stdby.bf', 'idaSTRX_RX1_on2stdby.bf', 'idaSTRX_RX1_stdby2off.bf', 'idaSTRX_RX1_stdby2on.bf' 

RX_list = ['RX2', 'RX3', 'RX4']



def create_files():
    for file in file_list:

        with open(file, 'r') as f:
            file_text = f.read()


        for Rx in RX_list:
            new_file_txt = re.sub("^RX1.", f"{Rx}.", file_text, flags=re.M)
            with open(file.replace('RX1', Rx), 'w') as f:
                f.write(new_file_txt)



if __name__ == '__main__':
    create_files()