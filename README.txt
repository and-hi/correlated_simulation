This R project simulates outbreaks inte several time series, extending the simulations done in Noufaily 2013 (see folder assets).

When an outbreak occurs we can usually see signals in several closely related infection time series, i.e. neighbouring counties, similar ages. Noufaily 2013 only simulates independetn time series. Here we simulate outbreaks in several adjacent time series. This will help us to develop new algorithms that can combine signals from several time series.

# Author: Andreas Hicketier

ich habe gerade die Simulationen aus dem Noufaily Paper (im Anhang) nachgebaut und versucht, die Zeitreihen in Fig.  2 zu reproduzieren. Dabei hatte ich Schwierigkeiten mit Szenario 17/Fig. 2(d). Es kann sein, dass das auch deine Implementierung im Surveillance Package betrifft.
	
	Ich vermute, dass das daran liegt, dass die Parametrisierung der NegBinom-Verteiliung im Paper falsch ist. Dort ist mu der Erwartungswert und die Varianz ist ist gegeben durch mu*sigma, wobei sigma ein Dispersion Parameter ist. Normalerweise wird der Dispersionsparameter aber k genannt und die Varianz ist mu+mu^2/k (siehe z.B. die Hilfe für rnbinom in R). Ich vermute, dass das im Paper mit der quasi-Poissonverteilung verwechselt wurde. Siehe z.B. hier für eine passende Parametrisierung: https://en.wikipedia.org/wiki/Poisson_regression#Overdispersion_and_zero_inflation
	
	Wenn man mu*sigma = mu + mu^2/k nach k auflöst, bekommt man k = mu/(sigma-1). Wenn ich das benutze, bekomme ich auch das Szenario 17 viel passender zum Paper simuliert. Allerdings passen dann meiner Meinung nach die Szenarien 10 und 12, also b) und c) in Fig 2, nicht mehr. Siehe die angehängten Plots und den angehängten R-Code, mit den zwei Möglichkeiten in der Funktion.
	
	Ich weiß nicht, wie man in R von der quasi-Poisson Verteilung zieht und habe nur diesen einen halbseidenen blogpost gefunden, der meinen Vorschlag oben nutzt. https://www.r-bloggers.com/2012/08/generate-quasi-poisson-distribution-random-variable/ Hier ist es angeblich implementiert, aber die Formel ist falsch angegeben: https://rdrr.io/cran/predint/man/rqpois.html
	
	Du hast im Surveillance Package auch die "simple" Variante der Parametrisierung genutzt, wenn ich mich nicht irre. Hattest du dir damals Gedanken zu dieser Thematik gemacht?
