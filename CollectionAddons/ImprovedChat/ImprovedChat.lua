function RunImprovedChat()
-- Копирование чата
local tinsert, tremove, floor = table.insert, table.remove, math.floor
local CreateFrame, hooksecurefunc = CreateFrame, hooksecurefunc

local module = {}
module.defaultDB = {
    limit = 100
}

-- Создание фреймов
local scroll = CreateFrame("ScrollFrame", "$parentScroll", UIParent)
local slider = CreateFrame("Slider", "$parentScrollBar", scroll)
local editbox = CreateFrame("EditBox", "$parentCopyBox", scroll)
scroll:SetScrollChild(editbox)

scroll.tex = scroll:CreateTexture(nil, "BACKGROUND")
scroll.tex:SetTexture(0, 0, 0, 1)
scroll.tex:SetPoint("TOPLEFT", -3, 3)
scroll.tex:SetPoint("BOTTOMRIGHT", 2.5, -2.5)
scroll:Hide()
scroll:EnableMouseWheel(1)
scroll:SetScript("OnScrollRangeChanged", function(self, xrange, yrange)
    yrange = yrange or self:GetVerticalScrollRange()
    local value = slider:GetValue()
    slider:SetMinMaxValues(0, yrange)
    slider:SetValue(value > yrange and yrange or value)
    local m = self:GetHeight() + yrange
    local v = self:GetHeight()
    local ratio = v / m
    if ratio < 1 then
        local size = floor(v * ratio)
        slider.thumb:SetHeight(size)
        slider:Show()
    else
        slider:Hide()
    end
end)
scroll:SetScript("OnMouseWheel", function(self, delta)
    slider:SetValue(slider:GetValue() - delta * slider:GetHeight() / 2)
end)
scroll:SetScript("OnShow", function(self)
    local chatFrame = _G["ChatFrame" .. self:GetID()]

    self:SetAllPoints(chatFrame)
    editbox:SetFont(chatFrame:GetFont())
    editbox:SetSize(chatFrame:GetWidth(), chatFrame:GetHeight())

    for i = #chatFrame.history, 1, -1 do
        local separator = i ~= 1 and "\n" or ""
        editbox:Insert(chatFrame.history[i] .. separator)
    end
    editbox.text = editbox:GetText()
    editbox:SetScript("OnChar", function(self)
        self:SetText(self.text or '')
    end)
end)
scroll:SetScript("OnHide", function(self)
    editbox:SetText("")
    editbox:SetScript("OnChar", nil)
end)

slider:Hide()
slider:SetBackdrop({
    bgFile = "Interface\\BUTTONS\\WHITE8X8",
    tile = false,
    tileSize = 0,
    edgeFile = "Interface\\BUTTONS\\WHITE8X8",
    edgeSize = 1,
    insets = {
        left = -1,
        right = -1,
        top = -1,
        bottom = -1
    }
})
slider:SetBackdropColor(0, 0, 0, .7)
slider:SetBackdropBorderColor(.2, .2, .2, 1)
slider:SetThumbTexture("")
slider.thumb = slider:GetThumbTexture()
slider.thumb:SetHeight(50)
slider.thumb:SetTexture(1, .82, 0, 1)
slider:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 6, 0)
slider:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 6, 1)
slider:SetWidth(10)
slider:SetOrientation('VERTICAL')
slider:SetMinMaxValues(0, 0)
slider:SetValueStep(1)
slider:SetValue(0)
slider:SetAlpha(.5)
slider:SetScript("OnValueChanged", function(self, value)
    scroll:SetVerticalScroll(value)
end)

editbox:SetTextColor(1, 1, 1, 1)
editbox:SetFontObject(ChatFontNormal)
editbox:SetAutoFocus(true)
editbox:SetMultiLine(true)
editbox:SetMaxLetters(0)
editbox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
    scroll:Hide()
end)

for i = 1, NUM_CHAT_WINDOWS do
    local chatFrame = _G["ChatFrame" .. i]

    -- initialize message cache
    chatFrame.history = {}
    hooksecurefunc(chatFrame, "AddMessage", function(self, msg, r, g, b)
        if msg and r and g and b then
            local col = ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
            tinsert(chatFrame.history, 1, col .. msg:gsub("|r", col))
        elseif msg then
            tinsert(chatFrame.history, 1, "|cffffffff" .. msg)
        end

        if chatFrame.history[module.defaultDB.limit] then
            tremove(chatFrame.history, module.defaultDB.limit)
        end
    end)

    local chatFrameTab = _G["ChatFrame" .. i .. "Tab"]
    chatFrameTab:HookScript("OnDoubleClick", function(self, button)
        if button ~= "LeftButton" then
            return
        end
        if scroll:IsShown() then
            scroll:Hide()
        else
            scroll:SetID(self:GetID())
            scroll:Show()
        end
    end)
    chatFrameTab:HookScript("OnClick", function(self, button)
        if button ~= "LeftButton" or not scroll:IsShown() or scroll:GetID() == self:GetID() then
            return
        end
        scroll:Hide()
    end)
end

-- Показывает редкость предмета в облачке над персонажем

local select = select
local GetCVar = GetCVar

local message
local pattern = "|c.-|h%[(.-)%]|h|r"

local function onUpdate(self)
    self.updates = self.updates + 1
    -- seems to take one update for the text to properly appear in a chat bubble
    if message and (self.updates > 1 or self:Scan(message)) then
        message = nil
        self.updates = 0
        self:SetScript("OnUpdate", nil)
    end
end

local addon = CreateFrame("Frame")
addon:RegisterEvent("CHAT_MSG_SAY")
addon:RegisterEvent("CHAT_MSG_YELL")
addon:RegisterEvent("CHAT_MSG_PARTY")
addon:RegisterEvent("CHAT_MSG_PARTY_LEADER")
addon:SetScript("OnEvent", function(self, event, msg)
    local partyEvent = event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER"
    if (partyEvent and GetCVar("ChatBubblesParty")) or (not partyEvent and GetCVar("ChatBubbles")) then
        message = msg
        self:SetScript("OnUpdate", onUpdate)
    end
end)

addon.updates = 0

function addon:Scan(msg)
    if msg:find(pattern) then
        local plainMsg, numLinks = msg:gsub(pattern, "%1")

        for i = 1, WorldFrame:GetNumChildren() do
            local child = select(i, WorldFrame:GetChildren())
            for j = 1, child:GetNumRegions() do
                local region = select(j, child:GetRegions())
                if region and not region:GetName() and region:IsVisible() and region.GetText and region:GetText() ==
                    plainMsg then
                    local oldTextWidth = region:GetStringWidth()
                    local oldHeight = region:GetHeight()
                    region:SetText(msg)
                    local bracketWidth = (region:GetStringWidth() - oldTextWidth) / numLinks / 2 -- how much width we need to add to the bubble to compensate for the added brackets

                    -- add one bracket width until the bubble to longer has to create an extra line
                    while region:GetHeight() > oldHeight do
                        region:SetWidth(region:GetWidth() + bracketWidth)
                    end
                    return true
                end
            end
        end
    else
        return true
    end
end

-- Показывает иконки итемов / спеллов / ачивок из чата

local icon = CreateFrame('Button', '$parentIcon', ItemRefTooltip)
icon:SetSize(37, 37)
icon:SetPoint("TOPRIGHT", ItemRefTooltip, "TOPLEFT", 0.5, -1.5)
icon:Hide()
icon.border = icon:CreateTexture(nil, 'OVERLAY')
icon.border:SetTexture([[Interface\AchievementFrame\UI-Achievement-IconFrame]])
icon.border:SetTexCoord(0, .5625, 0, .5625)
icon.border:SetPoint("CENTER")
icon.border:SetSize(icon:GetWidth() + 7.5, icon:GetHeight() + 7.5)
icon.border:Hide()
ItemRefTooltip.icon = icon

ItemRefTooltip:HookScript('OnTooltipSetItem', function(self)
    local link = select(2, self:GetItem())
    if not link then
        return
    end
    local icon = GetItemIcon(link)
    self.icon:SetNormalTexture(icon)
    self.icon:Show()
end)
ItemRefTooltip:HookScript('OnTooltipSetSpell', function(self)
    local id = select(3, self:GetSpell())
    if not id then
        return
    end
    local icon = GetSpellTexture(id)
    self.icon:SetNormalTexture(icon)
    self.icon:Show()
end)
ItemRefTooltip:HookScript('OnTooltipSetAchievement', function(self)
    if not arg1 then
        return
    end
    local id = arg1:match('achievement:(%d+)')
    local icon = select(10, GetAchievementInfo(id))
    self.icon:SetNormalTexture(icon)
    self.icon:Show()
    self.icon.border:Show()
end)
ItemRefTooltip:HookScript('OnTooltipCleared', function(self)
    self.icon:Hide()
    self.icon.border:Hide()
end)

hooksecurefunc("SetItemRef", function(link, text, button)
    local icon
    local type, id = string.match(link, "^([a-z]+):(%d+)")
    -- if( type == "item" ) then
    -- icon = select(10, GetItemInfo(link))
    --[[else]]
    if (type == "spell" or type == "enchant") then
        icon = select(3, GetSpellInfo(id))
        -- elseif( type == "achievement" ) then
        -- icon = select(10, GetAchievementInfo(id))
    end

    if (not icon) then
        ItemRefTooltipTexture10:Hide()

        ItemRefTooltipTextLeft1:ClearAllPoints()
        ItemRefTooltipTextLeft1:SetPoint("TOPLEFT", ItemRefTooltip, "TOPLEFT", 8, -10)

        ItemRefTooltipTextLeft2:ClearAllPoints()
        ItemRefTooltipTextLeft2:SetPoint("TOPLEFT", ItemRefTooltipTextLeft1, "BOTTOMLEFT", 0, -2)
        return
    end

    ItemRefTooltipTexture10:ClearAllPoints()
    ItemRefTooltipTexture10:SetPoint("TOPLEFT", ItemRefTooltip, "TOPLEFT", -36.5, -1.5) -- , 8, -7
    ItemRefTooltipTexture10:SetTexture(icon)
    ItemRefTooltipTexture10:SetHeight(37) -- 20
    ItemRefTooltipTexture10:SetWidth(37) -- 20
    ItemRefTooltipTexture10:Show()

    -- ItemRefTooltipTextLeft1:ClearAllPoints()
    -- ItemRefTooltipTextLeft1:SetPoint("TOPLEFT", ItemRefTooltipTexture10, "TOPLEFT", 24, -2)

    -- ItemRefTooltipTextLeft2:ClearAllPoints()
    -- ItemRefTooltipTextLeft2:SetPoint("TOPLEFT", ItemRefTooltip, "TOPLEFT", 8, -28)

    local textRight = ItemRefTooltipTextLeft1:GetRight()
    local closeLeft = ItemRefCloseButton:GetLeft()

    if (closeLeft <= textRight) then
        ItemRefTooltip:SetWidth(ItemRefTooltip:GetWidth() + (textRight - closeLeft))
    end
end)

-- Ссылки из чата

local color = "FFFFDEAD"
local pattern1 = '(([%w_.~!*:@&+$/?%%#-]-)(%w[-.%w]*%.)(%w+)(:?)(%d*)(/?)([%w_.~!*:@&+$/?%%#=-]*))'
local pattern2 = '((%f[%w]%a+://)(%w[-.%w]*)(:?)(%d*)(/?)([%w_.~!*:@&+$/?%%#=-]*))'
local domains =
    [[.aaa.aarp.abarth.abb.abbott.abbvie.abc.abogado.abudhabi.ac.academy.accenture.accountant.accountants.aco.active.actor.ad.ads.adult.ae.aeg.aero.aetna.af.afl.africa.ag.agakhan.agency.ai.aig.aigo.airbus.airforce.airtel.akdn.al.alfaromeo.alibaba.alipay.allfinanz.allstate.ally.alsace.alstom.am.amazon.americanexpress.amex.amica.amsterdam.an.analytics.android.anz.ao.aol.apartments.app.apple.aq.aquarelle.ar.arab.aramco.archi.army.arpa.art.arte.as.asia.associates.at.attorney.au.auction.audi.audible.audio.auspost.author.auto.autos.aw.aws.ax.axa.az.azure.ba.baby.baidu.bananarepublic.band.bank.bar.barcelona.barclaycard.barclays.barefoot.bargains.baseball.basketball.bauhaus.bayern.bb.bbc.bbt.bbva.bcg.bcn.bd.be.beauty.beer.bentley.berlin.best.bestbuy.bet.bf.bg.bh.bharti.bi.bible.bid.bike.bing.bingo.bio.biz.bj.black.blackfriday.blanco.blockbuster.blog.bloomberg.blue.bm.bms.bmw.bn.bnl.bnpparibas.bo.boehringer.bom.bond.boo.book.booking.boots.bosch.bostik.boston.bot.boutique.box.bq.br.bradesco.bridgestone.broadway.broker.brother.brussels.bs.bt.budapest.bugatti.build.builders.business.buy.buzz.bv.bw.by.bz.bzh.ca.cab.cafe.cal.call.calvinklein.cam.camera.camp.cancerresearch.canon.capetown.capital.capitalone.car.caravan.cards.care.career.careers.cars.cartier.casa.case.cash.casino.cat.catering.catholic.cba.cbn.cbre.cbs.cc.cd.center.ceo.cern.cf.cfa.cfd.cg.ch.chanel.channel.chase.chat.cheap.chintai.christmas.chrome.chrysler.church.ci.cipriani.circle.cisco.citadel.citi.citic.city.ck.cl.claims.cleaning.click.clinic.clinique.clothing.cloud.club.clubmed.cm.cn.co.coach.codes.coffee.college.cologne.com.comcast.commbank.community.company.compare.computer.condos.construction.consulting.contact.contractors.cooking.cool.coop.corsica.country.coupon.coupons.courses.cr.credit.creditcard.creditunion.cricket.crown.crs.cruise.cruises.cs.csc.cu.cuisinella.cv.cw.cx.cy.cymru.cz.dabur.dad.dance.data.date.dating.datsun.day.dd.de.deal.dealer.deals.degree.delivery.dell.deloitte.delta.democrat.dental.dentist.desi.design.dev.dhl.diamonds.diet.digital.direct.directory.discount.discover.dish.diy.dj.dk.dm.dnp.do.docs.doctor.dodge.dog.doha.domains.dot.download.drive.dubai.duck.dunlop.dupont.durban.dvag.dz.earth.eat.ec.eco.edeka.edu.education.ee.eg.eh.email.emerck.energy.engineer.engineering.enterprises.epost.epson.equipment.er.ericsson.erni.es.esq.estate.esurance.et.etisalat.eu.eurovision.eus.events.everbank.example.exchange.expert.exposed.express.extraspace.fage.fail.fairwinds.faith.family.fan.fans.farm.farmers.fashion.fast.fedex.feedback.ferrari.ferrero.fi.fiat.fidelity.film.final.finance.financial.fire.firestone.firm.firmdale.fish.fishing.fit.fitness.fj.fk.flickr.flights.flir.florist.flowers.flsmidth.fly.fm.fo.foo.food.foodnetwork.football.ford.forex.forsale.forum.foundation.fox.fr.free.fresenius.frl.frogans.frontdoor.frontier.fujitsu.fujixerox.fun.fund.furniture.futbol.fx.fyi.ga.gal.gallery.gallo.gallup.game.games.gap.garden.gay.gb.gbiz.gd.gdn.ge.gea.gent.genting.gf.gg.gh.gi.gift.gifts.gives.giving.gl.glass.gle.global.globo.gm.gmail.gmbh.gmo.gmx.gn.godaddy.gold.goldpoint.golf.goodyear.goog.google.gop.gov.gp.gq.gr.grainger.graphics.gratis.green.gripe.grocery.group.gs.gt.gu.guardian.gucci.guide.guitars.guru.gw.gy.hair.hamburg.hangout.haus.hbo.hdfc.hdfcbank.health.healthcare.help.helsinki.here.hermes.hiphop.hisamitsu.hitachi.hiv.hk.hkt.hm.hn.hockey.holdings.holiday.homegoods.homes.homesense.honda.honeywell.horse.hospital.host.hosting.hot.hoteles.hotels.hotmail.house.how.hr.hsbc.ht.hu.hughes.hyatt.hyundai.ibm.ice.icu.id.ie.ieee.ifm.ikano.il.im.imdb.immo.immobilien.in.industries.infiniti.info.ing.ink.institute.insurance.insure.int.intel.international.intuit.invalid.investments.io.ipiranga.iq.ir.irish.is.iselect.ist.istanbul.it.itau.itv.iveco.jaguar.java.jcb.jcp.je.jeep.jetzt.jewelry.jm.jo.jobs.joburg.joy.jp.jpmorgan.juegos.juniper.kaufen.kddi.ke.kerryhotels.kerrylogistics.kerryproperties.kfh.kg.kh.ki.kia.kim.kinder.kindle.kitchen.kiwi.km.kn.koeln.komatsu.kp.kpmg.kr.krd.kred.kuokgroup.kw.ky.kyoto.kz.la.lacaixa.ladbrokes.lamborghini.lancaster.lancia.lancome.land.landrover.lanxess.lasalle.lat.latrobe.law.lawyer.lb.lc.lds.lease.leclerc.legal.lego.lexus.lgbt.li.liaison.lidl.life.lifeinsurance.lifestyle.lighting.like.lilly.limited.limo.lincoln.linde.link.lipsy.live.living.lixil.lk.loan.loans.local.localhost.locker.locus.lol.london.lotte.lotto.love.lpl.lplfinancial.lr.ls.lt.ltd.ltda.lu.lundbeck.lupin.luxe.luxury.lv.ly.ma.macys.madrid.maif.maison.makeup.man.management.mango.map.market.marketing.markets.marriott.maserati.mattel.mba.mc.mckinsey.md.me.med.media.meet.melbourne.meme.memorial.men.menu.metlife.mg.mh.miami.microsoft.mil.mini.mint.mit.mitsubishi.mk.ml.mlb.mm.mma.mn.mo.mobi.mobile.mobily.moda.moe.moi.mom.monash.money.monster.mormon.mortgage.moscow.moto.motorcycles.mov.movie.movistar.mp.mq.mr.ms.msd.mt.mtn.mtr.mu.museum.music.mutual.mv.mw.mx.my.mz.na.nadex.nagoya.name.nationwide.nato.natura.navy.nba.nc.ne.nec.net.netflix.network.neustar.new.newholland.news.nexus.nf.nfl.ng.ngo.nhk.ni.nico.nike.nikon.ninja.nissan.nissay.nl.no.nokia.nom.northwesternmutual.norton.now.np.nr.nra.nrw.nt.ntt.nu.nyc.nz.obi.observer.off.office.okinawa.om.omega.one.ong.onion.onl.online.ooo.open.oracle.orange.org.organic.origins.osaka.otsuka.ovh.pa.page.panasonic.paris.partners.parts.party.passagens.pay.pccw.pe.pet.pf.pfizer.pg.ph.pharmacy.philips.phone.photo.photography.photos.physio.piaget.pics.pictet.pictures.pid.pin.ping.pink.pioneer.pizza.pk.pl.place.play.playstation.plumbing.plus.pm.pn.pohl.poker.politie.porn.post.pr.praxi.press.prime.pro.prod.productions.prof.progressive.promo.properties.property.protection.pru.prudential.ps.pt.pub.pw.pwc.py.qa.qpon.quebec.quest.qvc.racing.radio.re.read.realestate.realtor.realty.recipes.red.redstone.rehab.reise.reisen.reit.reliance.ren.rent.rentals.repair.report.republican.rest.restaurant.review.reviews.rexroth.rich.ricoh.rio.rip.rmit.ro.rocher.rocks.rodeo.rogers.room.rs.rsvp.ru.rugby.ruhr.run.rw.rwe.ryukyu.sa.saarland.safe.safety.sakura.sale.samsung.sandvik.sandvikcoromant.sanofi.sap.sarl.save.saxo.sb.sbi.sbs.sc.sca.scb.schaeffler.schmidt.scholarships.school.schule.schwarz.science.scjohnson.scor.scot.sd.se.search.seat.secure.security.seek.select.sener.services.ses.seven.sew.sex.sexy.sfr.sg.sh.shangrila.sharp.shaw.shell.shiksha.shoes.shop.shopping.shouji.show.showtime.shriram.si.silk.sina.singles.site.sj.sk.ski.skin.sky.skype.sl.sling.sm.smart.smile.sn.sncf.so.soccer.social.softbank.software.sohu.solar.solutions.song.sony.soy.space.spiegel.sport.spot.spreadbetting.sr.ss.st.stada.staples.star.starhub.statebank.statefarm.statoil.stc.stcgroup.stockholm.storage.store.stream.studio.study.style.su.sucks.supplies.supply.support.surf.surgery.suzuki.sv.swatch.swiftcover.swiss.sx.sy.sydney.symantec.systems.sz.taipei.talk.taobao.target.tatamotors.tatar.tattoo.tax.taxi.tc.td.tdk.team.tech.technology.tel.telecity.telefonica.temasek.tennis.test.teva.tf.tg.th.theater.theatre.tickets.tienda.tiffany.tips.tires.tirol.tj.tjx.tk.tl.tm.tn.to.today.tokyo.tools.top.toray.toshiba.total.tours.town.toyota.toys.tp.tr.trade.trading.training.travel.travelchannel.travelers.travelersinsurance.trust.tt.tube.tui.tunes.tushu.tv.tvs.tw.tz.ua.ubs.uconnect.ug.uk.um.unicom.university.uno.uol.ups.us.uy.uz.va.vacations.vanguard.vc.ve.vegas.ventures.verisign.versicherung.vet.vg.vi.viajes.video.vig.viking.villas.vip.virgin.visa.vision.vista.vistaprint.vivo.vlaanderen.vn.vodka.volkswagen.volvo.vote.voting.voto.voyage.vu.vuelos.wales.walmart.walter.wang.wanggou.watch.watches.weather.weatherchannel.web.webcam.weber.website.wed.wedding.weibo.weir.wf.whoswho.wien.wiki.williamhill.win.windows.wine.winners.wme.wolterskluwer.woodside.work.works.world.wow.ws.wtc.wtf.xbox.xerox.xfinity.xihuan.xin.xxx.xyz.yachts.yahoo.yamaxun.yandex.ye.yodobashi.yoga.yokohama.you.youtube.yt.yu.za.zappos.zara.zero.zip.zippo.zm.zone.zr.zuerich.zw]]
local tlds = {}
for tld in domains:gmatch '%w+' do
    tlds[tld] = true
end
local function max4(a, b, c, d)
    return math.max(a + 0, b + 0, c + 0, d + 0)
end
local protocols = {
    [''] = 0,
    ['http://'] = 0,
    ['https://'] = 0,
    ['ftp://'] = 0
}

function formatURL(url)
    return ("|c%s|Hurl:%s|h[%s]|h|r"):format(color, url, url)
end

function makeClickable(self, event, msg, ...)
    local finished = {}

    for url, prot, subd, tld, colon, port, slash, path in msg:gmatch(pattern1) do
        if not finished[url] and protocols[prot:lower()] == (1 - #slash) * #path and not subd:find '%W%W' and
            (colon == '' or port ~= '' and port + 0 < 65536) and
            (tlds[tld:lower()] or tld:find '^%d+$' and subd:find '^%d+%.%d+%.%d+%.$' and
                max4(tld, subd:match '^(%d+)%.(%d+)%.(%d+)%.$') < 256) then
            finished[url] = true
            msg = msg:gsub(url:gsub("([%%%+%-%*%(%)%?%[%]%^])", "%%%1"), formatURL("%1"))
        end
    end

    for url, prot, dom, colon, port, slash, path in msg:gmatch(pattern2) do
        if not finished[url] and not (dom .. '.'):find '%W%W' and protocols[prot:lower()] == (1 - #slash) * #path and
            (colon == '' or port ~= '' and port + 0 < 65536) then
            finished[url] = true
            msg = msg:gsub(url:gsub("([%%%+%-%*%(%)%?%[%]%^])", "%%%1"), formatURL("%1"))
        end
    end

    return false, msg, ...
end

StaticPopupDialogs["CLICK_LINK_CLICKURL"] = {
    text = "URL",
    button1 = "Назад",
    timeout = 0,
    showAlert = 1,
    whileDead = true,
    preferredIndex = 3,
    hasEditBox = true,
    hasWideEditBox = true,
    OnShow = function(self, data)
        self.editBox:SetText(data.url)
        self.editBox:HighlightText()
        local editBox = _G[this:GetName() .. "WideEditBox"]
        if editBox then
            editBox:SetText(data.url)
            editBox:SetFocus()
            editBox:HighlightText()
        end
        local icon = _G[this:GetName() .. "AlertIcon"]
        if icon then
            icon:Hide()
        end
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnEnterPressed = function(self)
        self:GetParent():Hide()
    end,
    hideOnEscape = 1
}

local SetItemRef_orig = SetItemRef;
function ClickURL_SetItemRef(link, text, button)
    if link:sub(1, 3) == "url" then
        local url = link:sub(5)
        local d = {}
        d.url = url
        StaticPopup_Show("CLICK_LINK_CLICKURL", "", "", d)
    else
        SetItemRef_orig(link, text, button)
    end
end
SetItemRef = ClickURL_SetItemRef

local CHAT_TYPES = {"AFK", "BATTLEGROUND_LEADER", "BATTLEGROUND", "BN_WHISPER", "BN_WHISPER_INFORM", "CHANNEL", "DND",
                    "EMOTE", "GUILD", "OFFICER", "PARTY_LEADER", "PARTY", "RAID_LEADER", "RAID_WARNING", "RAID", "SAY",
                    "WHISPER", "WHISPER_INFORM", "YELL", "SYSTEM"}

for _, chat_type in pairs(CHAT_TYPES) do
    ChatFrame_AddMessageEventFilter("CHAT_MSG_" .. chat_type, makeClickable)
end

-- Сокращение чата

local _G = _G
local hooks = {}
local f

local function AddMessage(frame, text, red, green, blue, id)
    text = tostring(text) or ""

    text = text:gsub("%[Guild%]", "[G]")
    text = text:gsub("%[Officer%]", "[O]")
    text = text:gsub("%[Party%]", "[P]")
    text = text:gsub("%[Raid%]", "[R]")
    text = text:gsub("%[Raid Leader%]", "[RL]")
    text = text:gsub("%[Raid Warning%]", "[RW]")
    text = text:gsub("%[Battleground%]", "[BG]")
    text = text:gsub("%[Battleground Leader%]", "[BGL]")

    -- Numbered channels
    text = text:gsub("%[(%d+)%. General%]", "[%1. G]")
    text = text:gsub("%[(%d+)%. Trade%]", "[%1. T]")
    text = text:gsub("%[(%d+)%. LocalDefense%]", "[%1. LD]")
    text = text:gsub("%[(%d+)%. GuildRecruitment%]", "[%1. GR]")
    text = text:gsub("%[(%d+)%. WorldDefense%]", "[%1. WD]")
    text = text:gsub("%[(%d+)%. Поиск спутников%]", "[%Поиск]")

    return hooks[frame](frame, text, red, green, blue, id)
end

for i = 1, NUM_CHAT_WINDOWS do
    f = _G["ChatFrame" .. i]
    hooks[f] = f.AddMessage
    f.AddMessage = AddMessage
end

-- Убираем анонсы Circle

local SPAMM_PATTERNS = {
    "[Анонс БГ]:", "Авто-объявление", "Рейтинговое поле боя",
    "Welcome to World of Warcraft Server - WoW Circle",
    "На этой неделе доступен Наксрамас на героической сложности!",
    "В FFA пвп зоне появился сундук сокровищ!",
    "В личном кабинете имеется магазин, в котором вы можете воспользоваться множеством услуг, счет бонусов можно пополнить множеством разных способов.",
    "Наши официальные веб ресурсы",
    "Если у вашего персонажа появилась какая-то проблема, то сначала воспользуйтесь услугой AntiError в личном кабинете, а только потом пишите на форум.",
    "Вы можете голосовать за сервер в личном кабинете",
    "Остерегайтесь подделок! Все актуальные адреса личных кабинетов находятся на нашем главном сайте.",
    "Если Вы испытываете проблемы, когда квестовый предмет долго не выпадает с моба",
    "ознакомьтесь пожалуйста с темой ",
    "За битву на Арене 3х3 ты можешь получить боевые монеты! Надо торопиться, это долго не продлится!",
    "За битву на Арене 2х2 ты можешь получить боевые монеты! Надо торопиться, это долго не продлится!",
    "За битву на рейтинговом поле боя ты можешь получить боевые монеты! Надо торопиться, это долго не продлится!",
    "Перед завершением торговли пожалуйста проверьте передаваемые предметы и количество золота.",
    "Привет! Ты можешь участвовать в рейтинговых боях на полях боя. Играя рейтинговые бои и зарабатывая рейтинг можно получить PvP звания и различные награды в конце сезона. Записаться на рейтинговый бой можно в персональном меню (.menu).",
    "Состояние очереди для Случайное поле боя",
    "[Системное сообщение]:",
    "На этой неделе доступно Плато Солнечного Колодца на героической сложности!",
    "Зелли Керосинка кричит: Наш дирижабль отправляется в Громовой Утес! Кто хочет прокатиться по Степям - добро пожаловать на борт!",
    "Снорк Следопутка кричит: Дирижабль до Гром'гола прибыл! Все, кому в Тернистую долину - садитесь!",
    "Фрезза кричит: Дирижабль до Подгорода прибыл! Кому в Тирисфальские леса - садитесь!",
    'Разделение добычи производится по системе "Групповая очередь".',
    'Разыгрываются только предметы качества "Необычное и выше".',
    "Вы присоединились к рейдовой группе.",
    "Вы покинули рейдовую группу.",
    "вступает в бой.",
    "умирает.",
    'Вы находитесь в режиме наблюдения. Чтобы покинуть бой, щелкните правой кнопкой мыши по значку арены на мини-карте и выберите "Покинуть бой".',
    "Бой завершен. Поле боя закроется через 2 мин..",
    "Ошибка интерфейсной операции, вызванная модификацией",
}

local function CHAT_MSG_SYSTEM_filter(_, _, message)
    for i = 1, #SPAMM_PATTERNS do
        if message:find(SPAMM_PATTERNS[i], 1, true) then
            return true
        end
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", CHAT_MSG_SYSTEM_filter)

-- Скорость прокрутки при зажатом шифт

do
    local IsShiftKeyDown = IsShiftKeyDown
    local orig = FloatingChatFrame_OnMouseScroll
    local function FloatingChatFrame_OnMouseScroll_hk(...)
        if not IsShiftKeyDown() then
            return
        end
        for i = 1, 5 do
            orig(...)
        end
    end
    hooksecurefunc("FloatingChatFrame_OnMouseScroll", FloatingChatFrame_OnMouseScroll_hk)
end

CHAT_FRAME_FADE_OUT_TIME = 0.5
CHAT_TAB_HIDE_DELAY = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
end
