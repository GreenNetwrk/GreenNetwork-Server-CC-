--Made by WalkWay Team 
--[[ 
	Host ComputerCraft webpages
    Copyright (C) 2014-2016  WalkWay

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

local SoftwareVersion = "16.9.5 GN3 ALPHA"

--//Prep//--

local size = { term.getSize( ) } 

if not term.isColor( ) then
    print( "Download different version of GreenNetwork server for this type of computer" )
    error( "This version of GreenNetwork server is for advanced computers ONLY" )
end

if not http then
   error( "Error: HTTP REQUIRED!" )
end

if not fs.exists( "gnsettingsfiles" ) then
    fs.makeDir( "gnsettingsfiles" )
end

local whitelistCheck = { http.checkURL( "http://pyrite.yohosts.info" ) }
if not whitelistCheck[ 1 ] then
    error( "A fatal error has caused this: "..whitelistCheck[ 2 ] )
end

 local function httpGet( sURL, ... )
    local urlCheck = { http.checkURL( sURL ) }
    if not urlCheck[ 1 ] then
        error( "Bad request. Details: "..urlCheck[ 2 ] )
        
        return false
    else
        local httpContent = http.get( sURL )
        local pageContent = httpContent.readAll( )
        
        return pageContent
    end
 end

if not fs.exists( "gnsettingsfiles/GREENNETSERVEROWNER" ) then
    local owner = fs.open( "gnsettingsfiles/GREENNETSERVEROWNER", "w" )
    term.setBackgroundColor( colors.gray )
    term.clear( )
    paintutils.drawLine( 1, 1, size[ 1 ], 1, colors.lightGray )
    term.setCursorPos( 1, 1 )
    print( "Server Owner" )
    term.setBackgroundColor( colors.gray )
    term.setCursorPos( 1,3 )
    print( "Enter the server owner: " )
    local ownerName = read( )
    owner.write( ownerName )
    owner.close( )
 end
 
 --[[if not fs.exists( "gnsettingsfiles/GREENNETSERVERDOMAINSAVE" ) then --//Not ready to be used//--
    local domainfile = fs.open( "gnsettingsfiles/GREENNETSERVERDOMAINSAVE", "w" )
    term.setBackgroundColor( colors.gray )
    term.clear( )
    paintutils.drawLine( 1, 1, size[ 1 ], 1, colors.lightGray )
    term.setCursorPos( 1, 1 )
    print( "Domain Setup" )
    term.setBackgroundColor( colors.gray )
    term.setCursorPos( 1,3 )
    print( "Enter the server domain name: " )
 end
 
 --]]

 --//End Prep//--
 
 --//Define local vars//--
 
local serverMode = true

local requestCount = 0

local UIPage

local data = { }

local softwareBreak

local SSSMode = false

local domainName = "nodomain.gn" --DEMO

local serverOwner

local SSSFile = "sssdemo"

local SSSInit = false

local sssFunc

--//End Define Vars//--

--//Setup//--

if not fs.exists( "www" ) then
    fs.makeDir( "www" )
end
 
if not fs.exists( "www/index" ) then
    local file = fs.open( "www/index", "w" )
    file.write( "term.setBackgroundColor(colors.gray) term.clear( ) term.setCursorPos(1,1) if term.isColor( ) then term.setTextColor(colors.lime) else term.setTextColor(colors.white) end print('This is the GreenNet server default webpage')" )
    file.close( )
end

local ownerFile = fs.open( "gnsettingsfiles/GREENNETSERVEROWNER", "r" )
local serverOwner = ownerFile.readAll( )
ownerFile.close()

local function SSSProc( file )
    if fs.exists( file ) and not SSSInit then
        local file = fs.open( file, "r" )
        
        local code = file.readAll( )
        
        file.close( )
        
        local func = loadstring( code )
        
        SSSInit = true
        
        return func
     else
        return false
     end
end 
 --//End setup//--

--//GUI functions//--

local function homeUI( )
    UIPage = "home"
    
    term.setTextColor( colors.white )

    term.setBackgroundColor( colors.gray )
    term.clear( )
    paintutils.drawLine( 1, 1, size[ 1 ], 1, colors.lightGray )
    
    term.setCursorPos( 1, 1 )
    print( "Home | " )
    term.setCursorPos( 8, 1 )
    print( "Requests: " )
    term.setTextColor( colors.lime )
    term.setCursorPos( 18, 1 )
    write( requestCount )
    term.setCursorPos( 20,1 )
    term.setTextColor( colors.white )
    write( SoftwareVersion )
    
    term.setBackgroundColor( colors.gray )
    term.setCursorPos( 1, 3 )
    write( "Server power: " )
    
    if serverMode then
        term.setBackgroundColor( colors.lime )
        write( "On" )
        term.setBackgroundColor( colors.gray )
    else
        term.setBackgroundColor( colors.red )
        write( "Off" )
        term.setBackgroundColor( colors.gray )
    end
    
    term.setCursorPos( 1, 5 )
    print( "[Domain Settings Page]" )
    
    term.setCursorPos( 1, 7 )
    print( "[Exit GreenNet server]" )
    
    term.setCursorPos( 1, 9 )
    print( "[Server Side Script Setting]" )
    
    term.setCursorPos( 1, 11 )
    print( "[Server info]" )
    
    term.setCursorPos( 1, 13 )
    print( "[Power off server]" )
    
    term.setCursorPos( 1, 15 )
    print( "[Settings]" )

    term.setTextColor(colors.lightGray)
    term.setCursorPos( 1, 17 )
    print( "GreenNetwork File Host" )
    term.setTextColor( colors.white )
    
    term.setCursorPos( 1, size[ 2 ] )
    term.setTextColor( colors.lime )
    write( "Green" )
    term.setTextColor( colors.white )
    write( "Network" )
end

local function settingsUI( )
    UIpage = "settingsPage"
    
    term.setTextColor( colors.white )
    
    term.setBackgroundColor( colors.gray )
    term.clear( )
    paintutils.drawLine( 1, 1, size[ 1 ], 1, colors.lightGray )
    
    term.setCursorPos( 1, 1 )
    print( "Server Settings" )
    term.setBackgroundColor( colors.gray )
    term.setCursorPos( 1, 3 )
    print( "Nothing to see here... Yet" )

	term.setCursorPos( 1, size[ 2 ] )
    term.setTextColor( colors.lime )
    write( "Green" )
    term.setTextColor( colors.white )
    write( "Network" )

    sleep( 3 )
    homeUI( )
end

local function domainNameUI( )
    UIpage = "domainPage"
    
    term.setTextColor( colors.white )
    
    term.setBackgroundColor( colors.gray )
    term.clear( )
    paintutils.drawLine( 1, 1, size[ 1 ], 1, colors.lightGray )
    
    term.setCursorPos( 1, 1 )
    print( "Domain Settings" )
    term.setBackgroundColor( colors.gray )
    term.setCursorPos( 1, 3 )
    print( "Nothing to see here... Yet" )

	term.setCursorPos( 1, size[ 2 ] )
    term.setTextColor( colors.lime )
    write( "Green" )
    term.setTextColor( colors.white )
    write( "Network" )

    sleep( 3 )
    homeUI( )
end

local function serverInfoUI( )
    UIPage = "serverInfo"
    
    term.setTextColor( colors.white )
    
    term.setBackgroundColor( colors.gray )
    term.clear( )
    paintutils.drawLine( 1, 1, size[ 1 ], 1, colors.lightGray )
    
    term.setCursorPos( 1, 1 )
    print( "Server Info" )
    term.setBackgroundColor( colors.gray )
	
	term.setCursorPos(1, 3)
	write( "Server Owner: "..serverOwner )

    term.setCursorPos( 1, 5 )
    
    write( "Domain Name: "..domainName )
    
    term.setCursorPos( 1, 7 )
    if serverMode then
        write( "Server Power: " )
        
        term.setBackgroundColor( colors.lime )
        write( "On" )
    else
        term.setBackgroundColor( colors.red )
        write( "Off" )
    end
    term.setBackgroundColor( colors.gray )
    
    term.setCursorPos( 1, 9 )
    write( "Requests: " )
    term.setTextColor( colors.lime )
    write( requestCount )
    term.setTextColor( colors.white )
    
    term.setCursorPos( 1, 11 )
    print( "[Exit]" )

	term.setCursorPos( 1, size[ 2 ] )
    term.setTextColor( colors.lime )
    write( "Green" )
    term.setTextColor( colors.white )
    write( "Network" )
end

local function UISSS( )
    UIPage = "SSS"
    
    term.setTextColor( colors.white )
    
    term.setBackgroundColor( colors.gray )
    term.clear( )
    paintutils.drawLine( 1, 1, size[ 1 ], 1, colors.lightGray )
    
    term.setCursorPos( 1, 1 )
    print( "SSS" )
    term.setCursorPos( 1, 3 )
    term.setBackgroundColor( colors.gray )
    print( "SSS Mode:" )
    term.setCursorPos( 11, 3 )
    if SSS == true then
        term.setBackgroundColor( colors.lime )
        write( "On" )
        term.setBackgroundColor( colors.gray )
    else
        term.setBackgroundColor( colors.red )
        write( "Off" )
        term.setBackgroundColor( colors.gray )
    end
    
    term.setCursorPos( 1, 5 )
    print( "SSS File: "..SSSFile )
    
    term.setCursorPos( 1, 7 )
    print( "[Home]" )
    
    term.setCursorPos( 1, 9 )
    term.setTextColor( colors.lightGray )
    print( "Server Side Scripting (SSS) is a background program that helps run the website" )
	
	term.setCursorPos( 1, size[ 2 ] )
    term.setTextColor( colors.lime )
    write( "Green" )
    term.setTextColor( colors.white )
    write( "Network" )
end

--//End GUI function(s)//--

--//Request control//--

local function pageRequestHandle( )
    
end

--//Request control//--

--//Logic code//--

local function UIHandle( )
    data = { os.pullEvent( "mouse_click" ) }
    if UIPage == "home" then
        if data[ 4 ] == 5 and data[ 3 ] >= 1 and data[ 3 ] <= 22 then
            domainNameUI( )
        elseif data[ 4 ] == 7 and data[ 3 ] >= 1 and data[ 3 ] <= 22 then
            softwareBreak = true
            term.clear( )
            term.setCursorPos( 1, 1 )
            print( "Good Bye!" )

			term.setCursorPos( 1, size[ 2 ] )
   			term.setTextColor( colors.lime )
    		write( "Green" )
    		term.setTextColor( colors.white )
    		write( "Network" )
        elseif data[ 4 ] == 9 and data[ 3 ] >= 1 and data[ 3 ] <= 28 then
            UISSS( )
        elseif data[ 4 ] == 3 and data[ 3 ] >= 14 and data[ 3 ] <= 16 then
            if serverMode then
                serverMode = false
            else
                serverMode = true
            end
            homeUI( )
        elseif data[ 4 ] == 11 and data[ 3 ] >= 1 and data[ 3 ] <= 13 then 
            serverInfoUI( )
        elseif data[ 4 ] == 13 and data[ 3 ] >= 1 and data[ 3 ] <= 18 then 
            os.shutdown( )
        elseif data[ 4 ] == 15 and data[ 3 ] >= 1 and data[ 3 ] <= 10 then
            settingsUI( )
        end
    elseif UIPage == "SSS" then
        if data[ 4 ] == 3 and data[ 3 ] >= 10 and data[ 3 ] <= 13 then
            if SSS then
                SSS = false
            else
                SSS = true
            end
            UISSS( )
        elseif data[ 4 ] == 7 and data[ 3 ] >= 1 and data[ 3 ] <= 6 then
            homeUI( )
        end
    elseif UIPage == "serverInfo" then
        if data[ 4 ] == 11 and data[ 3 ] >= 1 and data[ 3 ] <= 6 then
            homeUI( )
        end
    end
end

--//End logic code//--

--DEMO CODE
homeUI( )
while true do
    UIHandle( )
	
	if softwareBreak then
		break
	end
end
