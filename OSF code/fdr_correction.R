# FDR correction 

# model 1:

corrected_1_drowsy <- p.adjust(p_1_drowsy, method = 'fdr', n = length(p_1_drowsy))
corrected_1_dif <- p.adjust(p_1_dif, method = 'fdr', n = length(p_1_drowsy))
corrected_1_drodif <- p.adjust(p_1_drodif, method = 'fdr', n = length(p_1_drowsy))


# model 2:

corrected_2_neural <- p.adjust(p_2_neural, method = 'fdr', n = length(p_2_neural))
corrected_2_drowsy <- p.adjust(p_2_drowsy, method = 'fdr', n = length(p_2_neural))
corrected_2_dif <- p.adjust(p_2_dif, method = 'fdr', n = length(p_2_neural))
corrected_2_trudro <- p.adjust(p_2_trudro, method = 'fdr', n = length(p_2_neural))
corrected_2_trudif <- p.adjust(p_2_trudif, method = 'fdr', n = length(p_2_neural))
corrected_2_drodif <- p.adjust(p_2_drodif, method = 'fdr', n = length(p_2_neural))
corrected_2_trudrodif <- p.adjust(p_2_trudrodif, method = 'fdr', n = length(p_2_neural))
