//
//  URLSchema+RegularExpression.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension String {
    
    func matchURLSchema(fromPosition position: Int = 0, options: AnyObject...) -> [Match]? {
        
        func returnMatch(_ rawStringValue: String) -> [Match] {
            
            return [Match(start: position, end: rawStringValue.length + position)]
        }
        
        if let firstLetter = lowercaseCharAt(position) {
            
            switch firstLetter {
                
            case §UnicodeLetter.a:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.AAA, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.AAA)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.AAAS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.AAAS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.ABOUT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.ABOUT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.ADIUMXTRA, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.ADIUMXTRA)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.AFP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.AFP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.AFS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.AFS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.AIM, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.AIM)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.APT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.APT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.ATTACHMENT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.ATTACHMENT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.AW, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.AW)
                }
                
            case §UnicodeLetter.b:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.BESHARE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.BESHARE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.BITCOIN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.BITCOIN)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.BOLO, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.BOLO)
                }
                
            case §UnicodeLetter.c:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.CALLTO, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CALLTO)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.CAP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CAP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.CHROME, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CHROME)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.CHROME_EXTENSION, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CHROME_EXTENSION)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.CID, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CID)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.COAP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.COAP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.COM_EVENTBRITE_ATTENDEE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.COM_EVENTBRITE_ATTENDEE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.CONTENT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CONTENT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.CRID, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CRID)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.CVS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.CVS)
                }
                
            case §UnicodeLetter.d:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.DATA, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DATA)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DAV, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DAV)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DICT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DICT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DLNA_PLAYCONTAINER, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DLNA_PLAYCONTAINER)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DLNA_PLAYSINGLE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DLNA_PLAYSINGLE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DNS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DNS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DOI, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DOI)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DTN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DTN)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.DVB, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.DVB)
                }
                
            case §UnicodeLetter.e:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.ED2K, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.ED2K)
                }
                
            case §UnicodeLetter.f:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.FACETIME, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.FACETIME)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.FEED, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.FEED)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.FILE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.FILE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.FINGER, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.FINGER)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.FISH, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.FISH)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.FTP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.FTP)
                }
                
            case §UnicodeLetter.g:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.GEO, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.GEO)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.GG, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.GG)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.GIT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.GIT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.GIZMOPROJECT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.GIZMOPROJECT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.GO, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.GO)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.GOPHER, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.GOPHER)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.GTALK, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.GTALK)
                }
                
            case §UnicodeLetter.h:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.H323, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.H323)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.HCP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.HCP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.HTTP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.HTTP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.HTTPS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.HTTPS)
                }
                
            case §UnicodeLetter.i:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.IAX, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IAX)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.ICAP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.ICAP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.ICON, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.ICON)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IM, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IM)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IMAP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IMAP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.INFO, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.INFO)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IPN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IPN)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IPP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IPP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRC, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRC)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRC6, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRC6)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRCS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRCS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRIS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRIS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRIS_BEEP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRIS_BEEP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRIS_LWZ, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRIS_LWZ)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRIS_XPC, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRIS_XPC)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.IRIS_XPCS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.IRIS_XPCS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.ITMS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.ITMS)
                }
                
            case §UnicodeLetter.j:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.JAR, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.JAR)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.JAVASCRIPT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.JAVASCRIPT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.JMS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.JMS)
                }
                
            case §UnicodeLetter.k:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.KEYPARC, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.KEYPARC)
                }
                
            case §UnicodeLetter.l:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.LASTFM, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.LASTFM)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.LDAP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.LDAP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.LDAPS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.LDAPS)
                }
                
            case §UnicodeLetter.m:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.MAGNET, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MAGNET)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MAILTO, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MAILTO)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MAPS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MAPS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MARKET, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MARKET)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MESSAGE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MESSAGE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MID, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MID)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MMS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MMS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MS_HELP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MS_HELP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MSNIM, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MSNIM)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MSRP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MSRP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MSRPS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MSRPS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MTQP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MTQP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MUMBLE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MUMBLE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MUPDATE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MUPDATE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.MVN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.MVN)
                }
                
            case §UnicodeLetter.n:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.NEWS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.NEWS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.NFS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.NFS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.NI, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.NI)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.NIH, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.NIH)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.NNTP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.NNTP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.NOTES, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.NOTES)
                }
                
            case §UnicodeLetter.o:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.OID, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.OID)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.OPAQUELOCKTOKEN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.OPAQUELOCKTOKEN)
                }
                
            case §UnicodeLetter.p:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.PALM, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.PALM)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.PAPARAZZI, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.PAPARAZZI)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.PLATFORM, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.PLATFORM)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.POP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.POP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.PRES, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.PRES)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.PROXY, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.PROXY)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.PSYC, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.PSYC)
                }
                
            case §UnicodeLetter.q:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.QUERY, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.QUERY)
                }
                
            case §UnicodeLetter.r:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.RES, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.RES)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.RESOURCE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.RESOURCE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.RMI, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.RMI)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.RSYNC, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.RSYNC)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.RTMP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.RTMP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.RTSP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.RTSP)
                }
                
            case §UnicodeLetter.s:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.SECONDLIFE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SECONDLIFE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SERVICE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SERVICE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SESSION, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SESSION)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SFTP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SFTP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SGN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SGN)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SHTTP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SHTTP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SIEVE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SIEVE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SIP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SIP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SIPS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SIPS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SKYPE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SKYPE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SMB, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SMB)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SMS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SMS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SNMP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SNMP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SOAP_BEEP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SOAP_BEEP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SOAP_BEEPS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SOAP_BEEPS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SOLDAT, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SOLDAT)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SPOTIFY, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SPOTIFY)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SSH, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SSH)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.STEAM, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.STEAM)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.SVN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.SVN)
                }
                
            case §UnicodeLetter.t:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.TAG, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TAG)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.TEAMSPEAK, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TEAMSPEAK)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.TEL, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TEL)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.TELNET, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TELNET)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.TFTP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TFTP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.THINGS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.THINGS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.THISMESSAGE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.THISMESSAGE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.TIP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TIP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.TN3270, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TN3270)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.TV, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.TV)
                }
                
            case §UnicodeLetter.u:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.UDP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.UDP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.UNREAL, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.UNREAL)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.URN, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.URN)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.UT2004, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.UT2004)
                }
                
            case §UnicodeLetter.v:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.VEMMI, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.VEMMI)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.VENTRILO, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.VENTRILO)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.VIEWSOURCE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.VIEWSOURCE)
                }
                
            case §UnicodeLetter.w:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.WEBCAL, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.WEBCAL)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.WS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.WS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.WSS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.WSS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.WTAI, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.WTAI)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.WYCIWYG, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.WYCIWYG)
                }
                
            case §UnicodeLetter.x:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.XCON, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.XCON)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.XCON_USERID, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.XCON_USERID)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.XFIRE, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.XFIRE)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.XMLRPC_BEEP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.XMLRPC_BEEP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.XMLRPC_BEEPS, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.XMLRPC_BEEPS)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.XMPP, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.XMPP)
                }
                else if hasPrefixFromPositionCaseInsensitive(§URLSchema.XRI, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.XRI)
                }
                
            case §UnicodeLetter.y:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.YMSGR, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.YMSGR)
                }
                
            case §UnicodeLetter.z:
                
                if hasPrefixFromPositionCaseInsensitive(§URLSchema.Z39_50S, fromPosition: position) {
                    
                    return returnMatch(§URLSchema.Z39_50S)
                }
                
            default:
                
                return nil
            }
        }
        
        return nil 
    }

    
}
