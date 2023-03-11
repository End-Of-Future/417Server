--NEWGAME! 饭岛结音
local m=10700566
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
    c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --todeck
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,m+1)
	e5:SetTarget(cm.tdtg2)
	e5:SetOperation(cm.tdop2)
	c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetDescription(aux.Stringid(m,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,m)
    e6:SetTarget(cm.tdtg)
	e6:SetOperation(cm.tdop)
    c:RegisterEffect(e6)
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
    e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_TO_DECK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end

function cm.lcheck(g,lc)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
    if chkc then return chkc:IsLocation(0x0c) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0x0c,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0x0c,0,1,2,nil)
	Duel.HintSelection(g)
    g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,nil,nil)
end

function cm.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0x02,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x02)
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if c:IsRelateToEffect(e) and #tg>0 then
		tg:AddCard(c)
        Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
    end
end

function cm.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0x02,0,1,2,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			g:AddCard(c)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_LINK)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end

function cm.optfilter(c)
	return c:IsFaceup() and c:GetAttack()~=0
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroup(cm.optfilter,tp,0x04,0x04,nil)~=0 and Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	    local g=Duel.SelectMatchingCard(tp,cm.optfilter,tp,0x04,0x04,1,1,nil)
        if #g>0 then
            Duel.HintSelection(g)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(0)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            g:GetFirst():RegisterEffect(e1)
        end
    else
        Duel.Recover(tp,500,REASON_EFFECT)
    end
end