--异世界四重奏
local m=10700530
local cm=_G["c"..m]

function cm.initial_effect(c)
    aux.AddCodeList(c,10700108) --Tanya
    aux.AddCodeList(c,10700141) --KONOSUBA
    aux.AddCodeList(c,10700506) --Overlord
    aux.AddCodeList(c,10700512) --Re0
    aux.AddCodeList(c,10700521) --ShieldHero
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition)
    e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end

function cm.filterck(c,code)
    return aux.IsCodeListed(c,code) and c:IsFaceup()
end

function cm.confilter(c)
    return cm.filterck(c,10700108) or cm.filterck(c,10700141) or cm.filterck(c,10700506) or cm.filterck(c,10700512) or cm.filterck(c,10700521)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.confilter,tp,0x04,0,1,nil)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end

function cm.filter1(c,code)
    return aux.IsCodeListed(c,code) and not Duel.IsExistingMatchingCard(cm.filterck,c:GetControler(),0x04,0,1,nil,code)
end

function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_LINK) and
    (cm.filter1(c,10700108) or cm.filter1(c,10700141) or cm.filter1(c,10700506) or cm.filter1(c,10700512) or cm.filter1(c,10700521))
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function cm.tgtfilter(c)
    return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and cm.confilter(c)
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.tgtfilter,tp,0x30,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,math.min(#g,5),nil,nil)
end

function cm.optfilter(g)
    local g1=g:Filter(cm.filterck,nil,10700108)
    local g2=g:Filter(cm.filterck,nil,10700141)
    local g3=g:Filter(cm.filterck,nil,10700506)
    local g4=g:Filter(cm.filterck,nil,10700512)
    local g5=g:Filter(cm.filterck,nil,10700521)
    return #g1<=1 and #g2<=1 and #g3<=1 and #g4<=1 and #g5<=1
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.tgtfilter,tp,0x30,0,1,nil)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        g=g:SelectSubGroup(tp,cm.optfilter,false,1,math.min(#g,5))
        if #g>0 then
            Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        end
    end
end