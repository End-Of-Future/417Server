--深渊魔导
local m=10770000
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)
    c:EnableReviveLimit()
	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(cm.adval)
	c:RegisterEffect(e6)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e6)
	c:RegisterEffect(e2)
    --splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.regcon)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
    --destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(cm.reptg)
	c:RegisterEffect(e4)
    --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,m+1)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end

function cm.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK) and g:GetClassCount(Card.GetCode)==#g
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

function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if #g==0 then
        e:GetLabelObject():SetLabel(0)
    else
        local g1=g:Filter(Card.IsLink,nil,2)
        local num=0
        for tc in aux.Next(g1) do
            num=num+tc:GetBaseAttack()
        end
        e:GetLabelObject():SetLabel(num)
    end
end

function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0x0c,0x0c,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0x0c,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end

function cm.adval(e,c)
	return e:GetLabel()
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil,tp,POS_FACEUP) and c:GetFlagEffect(m+1)<=1 end
	if Duel.SelectEffectYesNo(tp,c,96) then
        c:RegisterFlagEffect(m+1,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil,tp,POS_FACEUP)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end

function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(3)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,0x10,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,0x10,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,nil,nil)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT) then
        Duel.ConfirmCards(1-tp,tc)
    end
end