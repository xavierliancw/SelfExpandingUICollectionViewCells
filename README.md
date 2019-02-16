# SelfExpandingUICollectionViewCells
I heard UICollectionViewCells can be responsible for sizing themselves. I'm going to find out now!

Sigh...

This is not a robust solution at all. It works in this specific case, but as soon as I add any more complexity to it (e.g. different kinds of cells), things start falling apart.

I've been digging around Google a lot and there just doesn't seem to be a tried and true native solution that leverages the SDK (as of 15 February 2019).

I'm going to shelve this until Apple comes out with a solution (probably some future WWDC video).

For now, I'll just go back to calculating and caching sizes like I've always done...
