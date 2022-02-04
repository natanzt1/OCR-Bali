function hasil = kamus_aksara(predictedLabels)
    if predictedLabels == "ulu"
        aksara = "i";
    elseif predictedLabels == "cecek"
        aksara = "ng";
    elseif predictedLabels == "taleng"
        aksara = "e";
    elseif predictedLabels == "pepet"
        aksara = "e";
    elseif predictedLabels == "suku"
        aksara = "u";
    elseif predictedLabels == "bisah"
        aksara = "h";
    elseif predictedLabels == "tedong"
        aksara = "a";
    elseif predictedLabels == "surang"
        aksara = "r";
    elseif predictedLabels == "titik"
        aksara = ".";
    elseif predictedLabels == "koma"
        aksara = ",";
    elseif predictedLabels == "pa gantungan"
        predictedLabels = "pa gantung";
        aksara = "pa";
    elseif predictedLabels == "sa gantungan"
        predictedLabels = "sa gantung";
        aksara = "sa";
    else
        aksara = split(predictedLabels, ' ');
    end
    index = size(predictedLabels);
    if index > 1
        if aksara(2) == "tedong"
            hasil = [predictedLabels, string(strcat(aksara(1), ' ', aksara(2)))];
        end
    else
        hasil = [predictedLabels, string(aksara(1))];
    end
end