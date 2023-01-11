local m=72100079
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetSPSummonOnce(m)
	aux.AddXyzProcedure(c,nil,10,3,cm.ovfilter,aux.Stringid(m,1))
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
    local e3=Effect.CreataEffect(c)
    e3:SetDescription(aux.Stringid(m,4))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
   	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon)
   	e3:SetTarget(cm.mttg)
	e3:SetOperation(cm.mtop)
    local e4=Effect.CreataEffect(c)
    e4:SetDescription(aux.Stringid(m,5))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(cm.cost)
    e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
    local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,6))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.pencon)
	e6:SetTarget(cm.pentg)
	e6:SetOperation(cm.penop)
	c:RegisterEffect(e6)
end
cm.pendulum_level=10
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x13b) and c:IsRankAbove(7)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
function cm.thfilter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function cm.mtfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsLevelBelow(5) or c:IsRankBelow(5))
end  
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end  
end  
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.Overlay(c,g)
	end  
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.xfilter(c)  
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsPosition(POS_FACEUP)
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
    local c=tc:GetFirst()
    local atk=c:GetBaseAttack()
    local xyz=e:GetHandler():GetOverlayGroup()
	if tc and tc:IsFaceup() and not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
        local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
        if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(math.ceil(atk/2))
			c:RegisterEffect(e2)
            Duel.BreakEffect()
            if xyz:IsSetCard(0x10db) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	            local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,2,nil)
             	if g:GetCount()>0 then
	                Duel.HintSelection(g) 
                    Duel.Destroy(g,REASON_EFFECT)
                    if xyz:IsSetCard(0x13b) then
                        local e1=Effect.CreateEffect(e:GetHandler())
	                	e1:SetType(EFFECT_TYPE_SINGLE)
		                e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		                e1:SetValue(1)
		                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		                c:RegisterEffect(e1)
                        local e1=Effect.CreateEffect(e:GetHandler())
	                	e1:SetType(EFFECT_TYPE_SINGLE)
		                e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		                e1:SetValue(1)
		                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		                c:RegisterEffect(e1)
                        if xyz:IsSetCard(0x99) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		                    local x=Duel.SelectMatchingCard(tp,cm.xfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	                     	if x:GetCount()>0 then
		                    	Duel.SpecialSummon(x,0,tp,tp,false,false,POS_FACEUP)
                            end
                        end
                    end
                end
            end
        end
    end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end