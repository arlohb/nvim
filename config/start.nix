{ pkgs, ... }:
{
  alpha-nvim = "
    require('alpha').setup {
      layout = {
        {
          type = 'padding',
          val = 12,
        },
        {
          type = 'text',
          val = [[
                            ....
                          .'' .'''
.                             .'   :
\\\\                          .:    :
\\\\                        _:    :       ..----.._
\\\\                    .:::.....:::.. .'         ''.
\\\\                 .'  #-. .-######'     #        '.
\\\\                 '.##'/ ' ################       :
\\\\                  #####################         :
\\\\               ..##.-.#### .''''###'.._        :
 \\\\             :--:########:            '.    .' :
  \\\\..__...--.. :--:#######.'   '.         '.     :
  :     :  : : '':'-:'':'::        .         '.  .'
  '---'''..: :    ':    '..'''.      '.        :'
     \\\\  :: : :     '      ''''''.     '.      .:
      \\\\ ::  : :     '            '.      '      :
       \\\\::   : :           ....' ..:       '     '.
        \\\\::  : :    .....####\\\\ .~~.:.             :
         \\\\':.:.:.:'#########.===. ~ |.'-.   . '''.. :
          \\\\    .'  ########## \\ \\ _.' '. '-.       '''.
          :\\\\  :     ########   \\ \\      '.  '-.        :
         :  \\\\'    '   #### :    \\ \\      :.    '-.      :
        :  .'\\\\   :'  :     :     \\ \\       :      '-.    :
       : .'  .\\\\  '  :      :     :\\ \\       :        '.   :
       ::   :  \\\\'  :.      :     : \\ \\      :          '. :
       ::. :    \\\\  : :      :    ;  \\ \\     :           '.:
        : ':    '\\\\ :  :     :     :  \\:\\     :        ..'
           :    ' \\\\ :        :     ;  \\|      :   .'''
           '.   '  \\\\:                         :.''
            .:..... \\\\:       :            ..''
           '._____|'.\\\\......'''''''.:..'''
                      \\\\
          ]],
          opts = {
            position = 'center',
          },
        },
      },
    }
  ";

  # TODO: Add back custom plugins
  # custom.drop-nvim = ''
  #   require("drop").setup {
  #     theme = "snow",
  #     max = 1000,
  #     interval = 70,
  #     screensaver = false,
  #   }
  # '';
}
