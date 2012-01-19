(def SAMPLE [
  [101, "hand", 12905, :noun],
  [111, "deur", 12076, :noun],
  [121, "heel", 11104, :other],
  [131, "binnen", 10161, :other],
  [141, "elkaar", 9676, :other],
  [151, "staan", 9125, :verb],
  [161, "verder", 8444, :other],
  [171, "erg", 7894, :other],
  [181, "want", 7428, :other],
  [191, "alsof", 7211, :other],
  [201, "handen", 6794, :noun],
  [211, "onder", 6555, :other],
  [221, "jaar", 6098, :noun],
  [231, "pakte", 5759, :verb],
  [241, "laatste", 5456, :adjective],
  [251, "gedaan", 5227, :verb],
  [261, "haalde", 4982, :verb],
  [271, "rond", 4625, :other],
  [281, "doe", 4448, :verb],
  [291, "uur", 4308, :noun],
  [301, "wakker", 4148, :adjective],
  [311, "vragen", 4043, :verb],
  [321, "naam", 3970, :noun],
  [331, "nodig", 3902, :other],
  [341, "lachte", 3765, :verb],
  [351, "legde", 3658, :verb],
  [361, "doet", 3581, :verb],
  [371, "richting", 3420, :noun],
  [381, "rug", 3304, :noun],
  [391, "a", 3248, :other],
  [401, "werden", 3145, :verb],
  [411, "mompelde", 3042, :verb],
  [421, "hart", 2903, :noun],
  [431, "kwaad", 2833, :adjective],
  [441, "goede", 2749, :adjective],
  [451, "zaal", 2594, :noun],
  [461, "ergens", 2539, :other],
  [471, "muur", 2486, :noun],
  [481, "begint", 2433, :verb],
  [491, "hou", 2347, :verb],
  [501, "word", 2277, :verb],
  [511, "moeilijk", 2192, :adjective],
  [521, "bos", 2157, :noun],
  [531, "raam", 2121, :noun],
  [541, "hetzelfde", 2033, :other],
  [551, "moesten", 2002, :verb],
  [561, "stak", 1949, :verb],
  [571, "geluid", 1906, :noun],
  [581, "leerlingen", 1873, :noun],
  [591, "meisjes", 1845, :noun],
  [601, "gooide", 1789, :verb],
  [611, "vandaan", 1747, :other],
  [621, "midden", 1709, :other],
  [631, "zetten", 1667, :verb],
  [641, "groep", 1615, :noun],
  [651, "gesprek", 1576, :noun],
  [661, "jen", 1555, :name],
  [671, "direct", 1520, :adjective],
  [681, "geloof", 1498, :verb],
  [691, "bezorgd", 1467, :adjective],
  [701, "zodra", 1454, :other],
  [711, "voelen", 1436, :verb],
  [721, "spullen", 1411, :noun],
  [731, "hing", 1391, :verb],
  [741, "bracht", 1367, :verb],
  [751, "donkere", 1329, :adjective],
  [761, "krijgt", 1304, :verb],
  [771, "blaise", 1296, :name],
  [781, "aantal", 1266, :noun],
  [791, "feit", 1248, :noun],
  [801, "lief", 1220, :adjective],
  [811, "schuld", 1209, :noun],
  [821, "mn", 1192, :other],
  [831, "oud", 1182, :adjective],
  [841, "hoek", 1168, :noun],
  [851, "gevallen", 1149, :noun],
  [861, "zachte", 1136, :adjective],
  [871, "tenminste", 1121, :other],
  [881, "aankeek", 1107, :verb],
  [891, "chingchuan", 1090, :name],
  [901, "badkamer", 1081, :noun],
  [911, "serieus", 1073, :adjective],
  [921, "emmett", 1067, :name],
  [931, "tom", 1057, :name],
  [941, "buik", 1039, :noun],
  [951, "moe", 1022, :adjective],
  [961, "veranderd", 1007, :verb],
  [971, "trekt", 996, :verb],
  [981, "boom", 989, :noun],
  [991, "tevoorschijn", 973, :other],
  [1001, "uil", 964, :noun],
  [1011, "geschreven", 953, :verb],
  [1021, "glimlachend", 944, :adjective],
  [1031, "tifa", 930, :name],
  [1041, "kalm", 923, :adjective],
  [1051, "im", 913, :other],
  [1061, "blonde", 901, :adjective],
  [1071, "ranko", 893, :name],
  [1081, "erbij", 883, :other],
  [1091, "ruzie", 876, :noun],
  [1101, "reactie", 864, :noun],
  [1111, "tong", 855, :noun],
  [1121, "dansen", 846, :verb],
  [1131, "herinnerde", 834, :verb],
  [1141, "inmiddels", 825, :other],
  [1151, "bel", 819, :verb],
  [1161, "marloes", 807, :name],
  [1171, "negeerde", 802, :verb],
  [1181, "mam", 794, :name],
  [1191, "maag", 783, :noun],
  [1201, "zeide", 772, :verb],
  [1211, "begrijpen", 765, :verb],
  [1221, "beschermen", 757, :verb],
  [1231, "mike", 749, :name],
  [1241, "slechts", 740, :other],
  [1251, "ivy", 732, :name],
  [1261, "tanden", 726, :noun],
  [1271, "emmet", 720, :name],
  [1281, "groen", 711, :adjective],
  [1291, "lege", 703, :adjective],
  [1301, "oma", 695, :noun],
  [1311, "bedenken", 693, :verb],
  [1321, "besluit", 685, :verb],
  [1331, "blikken", 678, :noun],
  [1341, "aarde", 674, :noun],
  [1351, "tovenaar", 665, :noun],
  [1361, "daarmee", 659, :other],
  [1371, "vaag", 648, :adjective],
  [1381, "vegeta", 639, :name],
  [1391, "steen", 634, :noun],
  [1401, "gezeten", 632, :verb],
  [1411, "sarah", 629, :name],
  [1421, "verdwijnen", 624, :verb],
  [1431, "gat", 619, :noun],
  [1441, "maand", 615, :noun],
  [1451, "groepje", 610, :noun],
  [1461, "vertrokken", 604, :verb],
  [1471, "gehaald", 601, :verb],
  [1481, "evers", 595, :name],
  [1491, "slim", 588, :adjective],
  [1501, "keuze", 586, :noun],
  [1511, "verslagen", 581, :verb],
  [1521, "free", 573, :other],
  [1531, "compleet", 570, :adjective],
  [1541, "zingen", 566, :verb],
  [1551, "poging", 561, :noun],
  [1561, "dom", 557, :adjective],
  [1571, "daarvan", 553, :other],
  [1581, "indruk", 549, :noun],
  [1591, "monster", 546, :noun],
  [1601, "orihime", 541, :name],
  [1611, "drank", 537, :noun],
  [1621, "gillen", 531, :verb],
  [1631, "redelijk", 524, :adjective],
  [1641, "traan", 519, :noun],
  [1651, "leraren", 516, :noun],
  [1661, "acht", 513, :other],
  [1671, "opgetrokken", 509, :verb],
  [1681, "bestaan", 507, :verb],
  [1691, "huilde", 503, :verb],
  [1701, "knipperde", 498, :verb],
  [1711, "verbergen", 495, :verb],
  [1721, "onderweg", 492, :other],
  [1731, "moed", 487, :noun],
  [1741, "gedrag", 483, :noun],
  [1751, "papa", 479, :name],
  [1761, "kin", 476, :noun],
  [1771, "ami", 473, :name],
  [1781, "dekens", 470, :noun],
  [1791, "get", 466, :other],
  [1801, "ouder", 462, :adjective],
  [1811, "gooien", 460, :verb],
  [1821, "herman", 456, :name],
  [1831, "delen", 451, :verb],
  [1841, "tuurlijk", 448, :other],
  [1851, "fleur", 447, :name],
  [1861, "wijst", 443, :verb],
  [1871, "captain", 440, :other],
  [1881, "meegenomen", 436, :verb],
  [1891, "mr", 434, :other],
  [1901, "ernstig", 431, :adjective],
  [1911, "geheime", 427, :adjective],
  [1921, "springt", 424, :verb],
  [1931, "nadenken", 422, :verb],
  [1941, "mompelt", 419, :verb],
  [1951, "yeah", 414, :other],
  [1961, "zwerkbal", 412, :noun],
  [1971, "spanning", 410, :noun],
  [1981, "hutkoffer", 408, :noun],
  [1991, "trillen", 406, :verb],
  [2001, "das", 405, :other],
  [2011, "kennis", 401, :noun],
  [2021, "brengt", 400, :verb],
  [2031, "enig", 397, :adjective],
  [2041, "dame", 394, :noun],
  [2051, "jetski", 392, :noun],
  [2061, "snelheid", 389, :noun],
  [2071, "stiekem", 386, :adjective],
  [2081, "benieuwd", 384, :adjective],
  [2091, "huisje", 382, :noun]])

(def FREQUENT ["de", "en", "ik", "het", "een", "ze", "hij", "dat", "haar", "niet", "van", "in", "zijn", "op", "je", "te", "was", "maar", "met", "naar"])
(def FACT-SIZE (* 4 (count FREQUENT)))
; (def ALL-FACT-SIZE (+ 4 FACT-SIZE))
(def ALL-FACT-SIZE FACT-SIZE)
(def SAMPLE-SIZE (count SAMPLE))

(defn fact-name [fact]
  (let [w (FREQUENT (quot fact 4))
        content (if (< fact FACT-SIZE)
                  (format (["gnief %s","gnief * %s","%s gnief","%s * gnief"] (mod fact 4)) w)
                  (str "ends with letter `" (["e" "s" "n" "t"] (- fact FACT-SIZE)) "`"))]
    (str "fact " fact " (" content ")")))


(defn facts-for-data [data cutoff]
  (let [calc-cutoff (fn [fact-index] (nth (sort (map #(% fact-index) data)) (int (* SAMPLE-SIZE cutoff))))
        cutoffs (vec (map calc-cutoff (range FACT-SIZE)))]
    (map
      (fn [sample-index]
        (let [facts (data sample-index)]
          (map (fn [fact-index] (>= (facts fact-index) (cutoffs fact-index))) (range FACT-SIZE))))
      (range SAMPLE-SIZE))))
    
(defn calc-s-kind [kind]
  (map last
       (filter (fn [[k i]] (= k kind))
               (map (fn [i] [((SAMPLE i) 3) i])
                    (range SAMPLE-SIZE)))))
  

(defn p-fact12 [pred]
  (fn [wlist-index fact1 fact2]
    (/ (max 0.5 (count (filter (pred wi fact1 fact2) wlist-index))) SAMPLE-SIZE)))

(defn two-facts [fr1 fr2]
  (let [bar (fn [acc fact1 fact2 s-kind p-kind]
              (let [p-fact ((p-fact12 pred) (range SAMPLE-SIZE) fact1 fact2)
                    p-fact-kind (/ (filter #(pred % fact1 fact2) s-kind) (count s-kind))
                    p-kind-fact (/ (* p-fact-kind p-kind) p-fact)
                    congruous (+ 1 (- p-kind) (* p-fact (- (* 2 p-kind-fact) 1)))]
                (conj acc [congruous (str "If " (fact_name fact1) " is " fr1 " and " (fact_name fact2) " is " fr2
                                          " , P(" kind "&fact) + P(~" kind "&~fact) is " (format "%.3f" congruous))])))]
    (map
      (fn [kind]
        (let [s-kind (calc-s-kind kind)
              p-kind (/ (count s-kind) SAMPLE-SIZE)]
          (take 5 (sort-by first > (reduce (fn [acc fact1] (reduce (fn [acc fact2] (bar acc fact1 fact2 s-kind p-kind)))) [] (range ALL-FACT-SIZE))))))
      [:noun,:name,:adjective,:verb])))

(defn process []
  (let [sample-ids (map first SAMPLE)
        data (eval (slurp "/tmp/x"))
        facts (facts-for-data data 0.5)
        process-permutation (fn [bit-permutations]
          (let [values (map #(bit-test bit-permutations %) (range bits))
                x-facts (if (= 2 bits) two-facts)
                frequencies (vec (map #(if v "frequent" "infrequent") values))
                arguments (conj frequencies
                                (fn [wi & fcts] (every? (fn [[f v]] (= v (get-in facts [wi f])))
                                                        (zipmap fcts values))))]
            (apply x-facts arguments))
        process-all-permutations (fn [bits] (reduce (fn [results binary] (conj results (process-permutation binary)))
                                                    []
                                                    (range (bit-shift-left 1 bits))))]
    
;    SAMPLE.each_with_index {|s,i| @facts[i] << (s[1][-1] == ?e) << (s[1][-1] == ?s) << (s[1][-1] == ?n) << (s[1][-1] == ?t) }
  
    (doall (map #(println %) (map (fn [x] (map last (take 5) (sort-by first >) (mapcat identity x)))
                                  (let [reports (foo 2)] (reduce (fn [acc reports] (map (fn [index] (let [report (reports index)] (conj acc report)))
                                                                                        (range (count reports))))
                                                                 (map (constantly []) (range (count reports)))
                                                                 (foo 3))))))
