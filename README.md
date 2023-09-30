# Making Bitmex Clone using Bitmex API !!

## Preview
![ezgif com-video-to-gif (1)](https://github.com/AnnaBaeTofuMom/BitmexClone/assets/61861862/df160b05-9da3-4a6e-8491-44e7b945a42e)

## Features
### Order Book
[X] Subscribe orderBookL2:XBTUSD topic and get data.  

[X] Use size property as quantity.  

[x] Show 20 rows of Bid/Ask orders each.  

[x] Show accumulated size in each rows.  


### Recent Trade
[x] Subscribe trade:XBTUSD topic and get data.   

[x] Show 30 recent trades.  

[x] Color Bid/Ask row in green/red.  

[ ] Fill backgrounds of newly added items with lighter green/red colors for 0.2 seconds.  

## Difficulties

### Data Consistency
There can be data consistency issues if the data received from the socket exceeds 100 records during CRUD operations. To ensure data consistency, I implemented a system where I store only 100 buy and sell orders locally. Initially, I planned to store 25 or 40 records, but I increased it to 100 to improve data consistency. Managing the array of data and ensuring seamless CRUD operations for these records was challenging.

### Time Complexity
I am not satisfied with the time complexity of my code. Although there are no N^2 iterations, I often check the entire length of the array, which can be inefficient. I believe there must be more efficient ways to handle this, but I am unsure about the best approach.

## Areas for Improvement

### Architecture Design
I feel the need to improve my skills in designing a robust system architecture. I am uncertain about the proper placement of files and components within the project, which indicates a gap in my understanding of good structural design principles.

### Integration of New Technologies
I had initially planned to implement SwiftUI and Actors, but I found it challenging to grasp these concepts fully while working on the project. Consequently, I decided to stick with the stacks such as UIKit and Rx, which I am familiar with. However, I regret not being able to put more time in learn and integrate these new technologies.

### Dependency Injection
I overlooked the part where dependency injection should have been implemented. It's a relatively simple aspect, but I missed it, and I acknowledge this as an area for improvement.

## Efforts Made
### Handling Data Race
The rapid influx of data through the socket posed a significant challenge regarding data race issues. To address this, I ensured that each view model maintains its separate queue, preventing data race problems and ensuring data consistency.

### Efforts During the Holiday 🍁
I had hoped to work on the project during the holiday period, but unexpected travel with my family and limited time hindered my progress. Nevertheless, I persevered and made consistent efforts to complete the assignment.



