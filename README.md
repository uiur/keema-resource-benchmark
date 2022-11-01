# benchmark
```
bundle exec ruby benchmark.rb
```

2022/11/01:

```
~/ghq/github.com/uiur/keema-resource-benchmark main
❯ bundle exec ruby benchmark.rb
Warming up --------------------------------------
                 ams    32.000  i/100ms
               keema   188.000  i/100ms
Calculating -------------------------------------
                 ams    306.014  (± 1.5%) i/s -      3.040k in  10.001799s
               keema      1.840k (± 1.1%) i/s -     18.424k in  10.054564s
                   with 95.0% confidence

Comparison:
               keema:     1840.3 i/s
                 ams:      306.0 i/s - 6.01x  (± 0.11) slower
                   with 95.0% confidence

Calculating -------------------------------------
                 ams   275.560k memsize (     0.000  retained)
                         3.822k objects (     0.000  retained)
                        15.000  strings (     0.000  retained)
               keema   214.808k memsize (   208.000  retained)
                         3.437k objects (     2.000  retained)
                         7.000  strings (     0.000  retained)

Comparison:
               keema:     214808 allocated
                 ams:     275560 allocated - 1.28x more
```
