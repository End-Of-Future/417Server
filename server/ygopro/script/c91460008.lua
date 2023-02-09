--问讯
local m=91460008
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,91460001)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(m)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m+1)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
    return c:IsCode(91460001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local opt=0
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,91460001) and Duel.SelectYesNo(tp,1463360130) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,91460001)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		opt=1
	end
	if opt==0 then
		opt=Duel.SelectOption(1-tp,1463360128,1463360129)
	else
		opt=Duel.SelectOption(1-tp,1463360128)
	end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsPlayerCanDraw(1-tp,1) then
            Duel.Draw(1-tp,1,REASON_EFFECT)
        end
    else
        Duel.RaiseEvent(e:GetHandler(),m,e,0,1-tp,tp,0)
	end
end
function cm.thfilter(c)
    return aux.IsCodeListed(c,91460001) and c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanSSet(tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
    if tc then
        Duel.SSet(tp,tc)
    end
end
