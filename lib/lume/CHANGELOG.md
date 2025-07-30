# lume v3.4.2

### Added:
    - lume.mapvalue() with inspiration from processing
    - lume.rerange() as better version of mapvalue
    - lume.random() fix by idbrii (David Briscoe)
    - lume.approx() from pull request
    - lume.max() and lume.min()
    - lume.deepclone() from Issue
    - lume.pop()
    - lume.removeall() and lume.removeswap()
    - lume.checksize()

### Changed:
    - lume.smooth() to lume.slerp() cause it's easier to switch between lerp and slerp
    - lume.count() to not use #t

### Removed:
    - lume.vector()

### Fixed:
    - pass keys to lume.map() callback
    - lume.format() to handle false values