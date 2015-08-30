# HHS Now Trending Challenge #

## The Challenge ##
The U.S. Office of the Assistant Secretary for Preparedness and Response (ASPR) has opened a new developer challenge: Now Trending - Health in My Community in March 2012.  The challenge invites developers to develop and submit a web-based application that tracks Twitter to identify trending illnesses in local communities.

## What is Pophealth Booster NowTrending? ##
Pophealth Booster NowTrending is a social media monitoring service providing local trends of health topics mentioned in tweets in real time. ASPR provides the topics of diseases and conditions concerning the public. From the free web application, public health professionals and consumers can look up top health trends in any local community or state. An open API is also available for any public health organizations to integrate the real-time health trending data into their websites or applications.

For HHS challenge: Total 25 public health topics from the Illness Term Taxonomy given by ASPR. Only top 5 topics are returned per location.

After challenge: Public health professionals can customize the health topics to meet their specific needs.

Locations:  About 500,000 unique locations from tweets as of 6/1/2012.
Public Web Access to Health Trending in Communities
On the public website Pophealth Booster NowTrending, user can look up a city, county, or state. If the local is found from Tweets mentioning any of the health topics, the health topics will be listed and ranked by the counts of tweets in the recent 24-48 hours. Only top 5 trending topics are shown to meet the challenge requirement (this number is configurable). For each health condition, health trend in the past 14 days is graphed as a bar chart. The average count is also provided for each topic at the location. Collectively, these information gives user a picture of how the health topics change over time in the communities he or she cares about.

Screenshot: Local Health Trend Now

## Open API for Local Health Trend Now ##
In addition to web access, public health organizations can also access local health trending data through the open API and integrate the data into their applications or websites.

REST API call URL and expected parameters:
http://host:port/swiserver/localtrendapi?appid=&method=getLocalTrend&local=

The XML response includes the top trending topics, each with recent tweet count and daily count for the past 14 days.

Screenshot: API Response in XML

## Overview of Top Communities Trending Now ##
User can get an overview of which communities are trending now. The communities are ranked by today’s total tweet counts of all health topics. Clicking on a community will show the details of health trends in that community.

Screenshot: Today’s Local Health Trends

## How Does It Work? ##

1. Set up health conditions to monitor
The NowTrending server is a dynamic server allowing user to set up health conditions for monitoring at any time.  For example, user can add or delete a health condition, add or delete synonyms of any condition. Once the change is saved, it will become effective immediately.

This control allows public health professionals to adjust what they want to monitor according to the needs of their communities.  User can add any other conditions that are not listed on the ASPR list.

It will be so easy for new user to get started - simply create an account and then add the health topics including synonyms to monitor local health trends right away.

2. Control tweet stream
The topics and synonyms are used to create a tweet stream from Twitter open API. Data are streaming from Twitter to the NowTrending server in real time continuously.

3. Identify location for tweets
If a tweet has geolocation information, this geolocation will be mapped to city, county or state.  If a tweet does not have geolocation, the location of the tweet author is used as a proxy.  The twitter user location is also mapped to city, county, or state.

4. Search topics in real time
Tweets are processed so that topics can be searched on tweets in real time. Counts of tweets for each topic at a given location is accumulated by date.

5. Present local trends on public web interface
When user looks up a local or state, topics are searched for that local or state. Tweet count for each topic within a 24-48 hours window is combined to show the current status. Health topics are ranked by this recent count and only the top 5 topics are presented to user. Trend for each topic is calculated as daily counts of tweets and graphed as bar chart.  Daily counts are averaged over a longer period of time to give a reference point.

6. Provide health trend data through open API
The same information shown on the web interface is also provided through an open API. Any application can make a REST call to the API with a location (city, county or state) to obtain the heath trending data in that location.

Screenshot: Set up health topics